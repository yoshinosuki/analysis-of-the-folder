import json
import matplotlib.pyplot as plt

# 汉字字体，优先使用楷
plt.rcParams['font.family'] = 'KaiTi'

# 定义文件类型和扩展名
file_categories = {
    "文本文件": [".txt", ".doc", ".docx", ".pdf", ".rtf", ".odt", ".md", ".epub"],
    "图片文件": [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".tiff", ".psd", ".webp"],
    "音频文件": [".mp3", ".wav", ".aac", ".flac", ".ogg"],
    "视频文件": [".mp4", ".avi", ".mkv", ".mov", ".wmv"],
    "压缩文件": [".zip", ".rar", ".7z", ".tar", ".gz"],
    "可执行文件": [".exe", ".bat", ".sh", ".msi", ".ps1"],
    "表格文件": [".xls", ".xlsx", ".ods"],
    "演示文稿文件": [".ppt", ".pptx", ".odp"],
    "数据库文件": [".mdb", ".accdb", ".sql", ".db"],
    "网页文件": [".html", ".htm", ".css", ".js"],
    "代码文件": [".c", ".cpp", ".java", ".py", ".js", ".php"],
    "配置文件": [".ini", ".json", ".xml", ".yaml"],
    "其他文件": []  # 添加“其他文件”类型，暂时不定义特定扩展名
}

# 定义读取 JSON 文件的函数
def read_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

# 自定义函数来格式化饼图的百分比
def func(pct):
    return f'{pct:.1f}%' if pct > 0 else ''

# 定义分类并绘制饼状图的函数
def plot_file_type_distribution(data):
    file_type_counts = {category: 0 for category in file_categories.keys()}
    other_file_extensions = []  # 用于存储其他文件的后缀名

    # 统计文件类型
    for folder, info in data.items():
        for file_type, count in info['FileTypes'].items():
            matched = False
            for category, extensions in file_categories.items():
                if file_type in extensions:
                    file_type_counts[category] += count
                    matched = True
                    break
            if not matched:
                file_type_counts["其他文件"] += count
                other_file_extensions.append(file_type)  # 收集“其他文件”的后缀名

    # 输出其他文件的后缀名
    print("被归类为其他文件的后缀名有：", set(other_file_extensions))

    # 过滤掉0%的类别
    labels = [label for label, size in file_type_counts.items() if size > 0]
    sizes = [size for size in file_type_counts.values() if size > 0]

    # 绘制饼状图
    plt.figure(figsize=(10, 7))
    plt.pie(sizes, labels=labels, autopct=func, startangle=140)
    plt.axis('equal')  # 使饼图为圆形
    plt.title('文件类型分布')
    plt.show()

def main():
    # 读取 JSON 文件
    json_file_path = r'C:\Users\surface\Desktop\fsdownload\output.json'  # 请替换为你的 JSON 文件路径
    data = read_json_file(json_file_path)

    # 绘制文件类型分布饼图
    plot_file_type_distribution(data)

if __name__ == "__main__":
    main()
