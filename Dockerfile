FROM continuumio/miniconda3

LABEL description = "Image for airway clustering project."
MAINTAINER "Rani Basna" ranibasna@gmail.com

# create data directory
RUN mkdir -p /01_data
RUN mkdir -p /03_output

# Add project files
COPY environment.yml ./
COPY Python_Functions ./Python_Functions/
COPY R_Functions ./R_Functions/

# Install conda environment
#RUN conda install -c r r r-devtools
#RUN conda install -c conda-forge r-factoextra
RUN conda install python=3.6
RUN conda install pandas
Run conda install rstudio
RUN conda env update -n base -f environment.yml



# run the script
CMD Rscript R_Functions/Get_Binary_data.R 01_data/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv 03_output/Airway2_binary.csv
