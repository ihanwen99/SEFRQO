import sys

sys.stdout = open('8B-Apr9-08:40GRPO_output.log', 'w')
sys.stderr = open('8B-training_error.log', 'w')

from load_dataset import hanwen_generate_grpo_dataset

sql2hints_data_dir = "hanwen_job_grpo.json"
dataset = hanwen_generate_grpo_dataset(sql2hints_data_dir)
print("=> Dataset length: ", len(dataset['answer']))

from unsloth import FastLanguageModel
from transformers import AutoTokenizer
from unsloth.chat_templates import get_chat_template

max_seq_length = 2500
lora_rank = 32

# base_model_name = "unsloth/Llama-3.2-3B-Instruct-unsloth-bnb-4bit"
# local_model_name = "3B-JOB-ckpts/ckpt-4296"
local_model_name = "8B-JOB-Apr2-ckpts/ckpt-1074"

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name=local_model_name,
    max_seq_length=max_seq_length,
    load_in_4bit=True,
    fast_inference=True,
    max_lora_rank=lora_rank,
    gpu_memory_utilization=0.9,
)
model = FastLanguageModel.get_peft_model(
    model,
    r=lora_rank,
    lora_alpha=lora_rank,
)
model.gradient_checkpointing_enable()

from trl import GRPOConfig, GRPOTrainer
from unsloth import is_bfloat16_supported

print("is_bfloat16_supported(): ", is_bfloat16_supported())

training_args = GRPOConfig(
    use_vllm=True,  # use vLLM for fast inference!
    learning_rate=1e-6,
    adam_beta1=0.9,  #
    adam_beta2=0.99,
    weight_decay=0.1,
    warmup_ratio=0.1,
    lr_scheduler_type="cosine",
    optim="paged_adamw_8bit",
    logging_steps=1,
    bf16=is_bfloat16_supported(),
    fp16=not is_bfloat16_supported(),
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,  # Increase to 4 for smoother training
    num_generations=4,  # Decrease if out of memory
    max_prompt_length=1500,
    max_completion_length=1000,
    # num_train_epochs = 1, # Set to 1 for a full training run
    max_steps=200,
    save_steps=100,
    max_grad_norm=0.1,
    report_to="none",  # Can use Weights & Biases
    output_dir="Latest-8B-GRPO",
)

from hanwen.reward_function.latency import latency_reward_func

trainer = GRPOTrainer(
    model=model,
    processing_class=tokenizer,
    reward_funcs=[
        # test_reward_function
        latency_reward_func
    ],
    args=training_args,
    train_dataset=dataset,
)
trainer.train()