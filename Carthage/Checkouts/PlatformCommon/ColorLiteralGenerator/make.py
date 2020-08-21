import csv
import matplotlib

def hex_to_rgb(value):
    value = value.lstrip('#')
    lv = len(value)
    return tuple(int(value[i:i+lv//3], 16) for i in range(0, lv, lv//3))

def readMyFile(filename):
    values = []
    

    with open(filename) as csvDataFile:
        csvReader = csv.reader(csvDataFile)
        for row in csvReader:
            rgb = matplotlib.colors.to_rgb("#" + row[2])
            shade = ""
            if row[1][0] != 'A':
                shade = "o" + row[1]
            else:
                shade = 'a' + row[1][1] + row[1][2] + row[1][3]
            formatted_str = 'case .%s: return #colorLiteral(red: %s, green: %s, blue: %s, alpha: 1) /* #%s */' % (shade, rgb[0], rgb[1], rgb[2], row[2])
            values.append(formatted_str)

    return values

    
values = readMyFile('material_design_color_palette.csv')
print(values)

#print(values, file = open('test.txt', 'w'))
with open("output.txt", "w") as txt_file:
    for line in values:
        txt_file.write(line + "\n")
