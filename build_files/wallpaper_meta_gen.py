import os

xml_lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">',
    '<wallpapers>'
]

for i in os.listdir("."):
    if i in ["README.md", ".gitattributes", ".git"]:
        print(i)
        continue

    xml_lines.append(f'  <wallpaper delete="false">')
    xml_lines.append(f'    <name>{i.split(".")[0]}</name>')
    xml_lines.append(f'    <filename>/usr/share/backgrounds/{i}</filename>')
    xml_lines.append(f'    <options>scaled</options>')
    xml_lines.append(f'    <shade_type>wallpaper</shade_type>')
    xml_lines.append(f'    <pcolor>#ffffff</pcolor>')
    xml_lines.append(f'    <pcolor>#000000</pcolor>')
    xml_lines.append(f'  </wallpaper>')

xml_lines.append("</wallpapers>")

with open("/usr/share/gnome-background-properties/extra-backgrounds.xml", "w") as f:
    f.write("\n".join(xml_lines))

    