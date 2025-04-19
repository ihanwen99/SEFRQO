
import time
from vllm import LLM, SamplingParams
from transformers import AutoTokenizer





local_model_name = "/home/qihanzha/LLM4QO/job-4296"
print(f"Model name: {local_model_name}")

# load tokenizer and model
local_tokenizer = AutoTokenizer.from_pretrained(local_model_name, trust_remote_code=True)
client_gpt = LLM(
        model=local_model_name,
        dtype="bfloat16",
    )
local_sampling_params = SamplingParams(
        temperature=1.0,
        max_tokens=512,
        n=1,
        stop_token_ids = [128009, 128001],
    )

# load domain from the file
with open(f"/home/qihanzha/LLM4QO/domain/x.txt", "r") as f:
    domain_nl = f.read()
    
messages = [{"role": "system", "content": domain_nl}]


        
       
   
# load combined query from the file
with open(f"/home/qihanzha/LLM4QO/combined_query/x.txt", "r") as f:
    combined_query = f.read()


messages.append({"role": "user", "content": combined_query})
        
      
after_template_messages = local_tokenizer.apply_chat_template(messages, add_generation_prompt=True, tokenize=False)
        
time_inference_start = time.time()
client_gpt.generate(after_template_messages, local_sampling_params)
time_inference_stop = time.time()
print(f"Inference time for question generation: {time_inference_stop - time_inference_start:.2f}s")
