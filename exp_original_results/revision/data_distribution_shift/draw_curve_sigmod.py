import pandas as pd
import matplotlib.pyplot as plt

plt.rcParams['pdf.fonttype'] = 42
plt.rcParams['ps.fonttype'] = 42
plt.rcParams['font.size'] = 18
plt.rcParams['axes.titlesize'] = 24
plt.rcParams['axes.labelsize'] = 16
plt.rcParams['xtick.labelsize'] = 16
plt.rcParams['ytick.labelsize'] = 18


import matplotlib.cm as cm

def plot_multiple_relative_execution_times(csv_files, model_names, workload):
    plt.figure(figsize=(10, 5))

    # 使用 matplotlib 的 tab10 调色板，最多支持10个高对比颜色
    colors = plt.get_cmap('tab10').colors

    for i, (csv_file, model_name) in enumerate(zip(csv_files, model_names)):
        try:
            df = pd.read_csv(csv_file)
        except Exception as e:
            print(f"无法读取文件 {csv_file}：{e}")
            continue

        if "Iteration" in df.columns and "Relative Time" in df.columns:
            df = df.sort_values(by="Iteration")
            x = df["Iteration"]
            y = df["Relative Time"]

            color = colors[i % len(colors)]  # 确保不会超出颜色范围
            plt.plot(x, y, label=f"{model_name}", linewidth=2, color=color)
        else:
            print(f"文件 {csv_file} 中缺少 'Iteration' 或 'Relative Time' 列。")

    plt.axhline(y=1, color='black', linestyle='--', linewidth=3)

    plt.xlabel("Iterations on Original IMDB Dataset")
    plt.ylabel("Relative Execution Time")
    # plt.title("RET per Iteration")

    plt.legend(ncol=2)

    plt.xlim(1, 50)
    plt.savefig(f"data_distribution_shift_relative_execution_time_{workload}.pdf")
    plt.show()

# CSV 文件路径和对应的模型名称
csv_files_CEB = [
    "/Users/qihanzhang/PycharmProjects/deal_llmqo_sigmod/revision/data_distribution_shift/8B_grpo_1ref_100iters_datashift_iteration_time_summary.csv",
    "/Users/qihanzhang/PycharmProjects/deal_llmqo_sigmod/revision/data_distribution_shift/8B_sft_1ref_100iters_datashift_iteration_time_summary.csv",
"/Users/qihanzhang/PycharmProjects/deal_llmqo_sigmod/iterations_main_evaluation_static/formal_50_prompt_FullPlan_NoExec_hanwen_sftgrpo_dynamicrag_imdb_8B.log_iteration_time_summary.csv",
    "/Users/qihanzhang/PycharmProjects/deal_llmqo_sigmod/iterations_main_evaluation_static/formal_50_1ref_FullPlan_NoExec_hanwen_sft_updaterag_new.log_iteration_time_summary.csv",

]


model_names = [
    "LSG8B-noise",
    "LS8B-noise",
    "LSG8B",
    "LS8B",
]

# 调用函数绘制图像
plot_multiple_relative_execution_times(csv_files_CEB, model_names, "CEB")
