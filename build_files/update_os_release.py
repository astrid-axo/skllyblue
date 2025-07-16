lines = []
def get_key(key: str):
    return [i for i in lines if key in i][0].split("=")[1].replace("\n", "").replace("\"", "")

def edit_key(key: str, val: str | int):
    dex = lines.index([i for i in lines if key in i][0])
    lines[dex] = f"{key}={f'"{val}"' if type(val) == str else val}\n"

with open("/etc/os-release", "r") as file:
    lines = file.readlines()
    edit_key("NAME", "SkllyBlue Linux")
    edit_key("PRETTY_NAME", get_key("NAME") + " " + get_key("VERSION"))
    edit_key("DEFAULT_HOSTNAME", "skllyblue")
    edit_key("HOME_URL", "https://github.com/astrid-axo/skllyblue")

with open("/etc/os-release", "w") as file:
    file.write("".join(lines))