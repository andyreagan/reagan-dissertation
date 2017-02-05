import json
import jinja2
from os.path import isfile,join

if __name__ == '__main__':
    table_template = jinja2.Template(r"""
\begin{tabular}{l | l | l | l}
  \hline
  Short name & Description & \# Samples & Referenced By\\
  \hline
{% for dataset in data %}{{ dataset.nickname }} & {{ dataset.fullname }} & {{ dataset.N }} & {{ dataset.reference }}\\
{% endfor %}
\end{tabular}
""")
    # {% for dataset in data %}{{ dataset.nickname }} & {{ dataset.fullname }} & {{ dataset.N }} & \cite{ {{- dataset.reference -}} }\\
    shortrefs = [["giachanou2016like","G"],
                 ["ribeiro2016sentibench","R"],
                 ["saif2013evaluation","S"],
                 ["luo2012opinion","L"]]
    f = open("datasets.json","r")
    data = json.loads(f.read())
    f.close()
    # drop the first two
    data = data[2:]
    for dataset in data:
        dataset["fullname"] = dataset["fullname"].replace("_",r"\_")
        dataset["nickname"] = dataset["nickname"].replace("_",r"\_")
        fname = join("/Users/andyreagan/projects/2015/03-sentiment-comparison/data/twitter-labeled-tweets/aggregated",dataset["datafile"])
        print(fname)
        for shortref in shortrefs:
            dataset["reference"] = dataset["reference"].replace(shortref[0],shortref[1])
        dataset["reference"] = dataset["reference"].replace(",",", ")
        if isfile(fname):
            f = open(fname,"r",encoding="utf8")
            dataset["N"] = str(len(f.read().split("\n")))
            f.close()
        else:
            print("couldn't find",dataset["datafile"]," for ",dataset["nickname"])
            dataset["N"] = "N/A"
    f = open("datasets.tex","w")
    f.write(table_template.render(data=data))
    f.close()
