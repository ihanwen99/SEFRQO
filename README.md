# SEFRQO: LLM-Based Query Optimization

Currenly we are still working on preparing the final version of the code before the camera-ready submission, so the fine-tuning part is still imcomplete. If you would like to replay the experiemnts, please use the following model checkpoints:
https://www.dropbox.com/scl/fo/y08hmd9s1q2dc34fwuqmv/AAgTB0TIfKMDpIdBo39Ve-w?rlkey=1sku3fckkvzegezpavhc5c2gu&st=lf18cpm4&e=1&dl=0

This branch contains the implementation of SEFRQO. The experimental data can be seen under the folder of `exp_original_results`.

You can reproduce the experiments described in our paper using either:
- Local LLMs (as specified in the paper), or
- APIs provided by services such as **OpenAI** or **DeepSeek**.

> ⚠️ Make sure to adjust any necessary paths in the Python scripts before running the experiments.

## Environment
- Python 3.10.16

## Example: Replay Static CEB Workload with 3B Model

To run the static CEB workload using the 3B model:

```bash
python /your_path/src/local_llm/local_version_general_online_record_sft_3B.py \
    > /your_path/test.log 2>&1
