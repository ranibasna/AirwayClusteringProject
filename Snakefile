rule get_converted_data:
    input:
        # data = 'Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv',
        data = '01_data/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv',
        script = 'R_Functions/Functions.R'
    output:
        data = 'Results/converted_data.csv'
    shell: "Rscript {input.script} {input.data} {output.data}"


rule get_result_DEC:
    input:
        # data_1 = 'Results/converted_data.csv',
        data_1 = rules.get_converted_data.output,
        # data_2 = 'Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv',
        data_2 = rules.get_converted_data.input.data,
        script = 'Python_Functions/code.py'
    output:
        'Results/result_airway_DEC.csv'
    shell: 'python3 {input.script} {input.data_1} {input.data_2} {output}'


# rule get_result_DEC:
#    input:
#        'Results/converted_data.csv',
#        'Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv'
#    output:
#        'Results/result_airway_DEC.csv'
#    shell: 'python3 Python_Functions/code.py {input} {output}'
    # shell: "Rscript {input.script} {input.data} {output.data}"

# python3 Python_Functions/code.py Intermediate/Preprocessed_data/converted_airway.csv Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv
# Results/result_airway_DEC.csv
# to generate the target result use the file name in the snackmake command
# snakemake Results/result_airway_DEC.csv
