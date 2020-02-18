FROM continuumio/miniconda3
#FROM ubuntu:18.04

LABEL description = "Image for airway clustering project."
MAINTAINER "Rani Basna" ranibasna@gmail.com

# create data directory
RUN mkdir -p /01_data
RUN mkdir -p /03_output
RUN mkdir -p /Results

# Add project files
COPY environment.yml ./
COPY Snakefile ./
COPY Python_Functions ./Python_Functions/
COPY R_Functions ./R_Functions/
COPY Results ./Results


#ENV PATH="/root/miniconda3/bin:${PATH}"
#ARG PATH="/root/miniconda3/bin:${PATH}"
#RUN apt-get update

#RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

#RUN wget \
#    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && mkdir /root/.conda \
#    && bash Miniconda3-latest-Linux-x86_64.sh -b \
#    && rm -f Miniconda3-latest-Linux-x86_64.sh \
#RUN conda --version

# Install conda environment
#RUN conda install -c conda-forge r-factoextra
RUN conda install python=3.6
RUN conda install pandas=0.24.2
#Run conda install rstudio=1.1.456
RUN conda env update -n base -f environment.yml



# run the script
#CMD Rscript R_Functions/Get_Binary_data.R 01_data/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv 03_output/Airway2_binary.csv

# CMD  Rscript R_Functions/Functions.R 01_data/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv 03_output/converet_airway.csv

#CMD Rscript R_Functions/Functions.R Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv  Results/converet_airway.csv

# CMD python3  Python_Functions/code.py Results/converet_airway.csv Original_Data/AirwayDiseasePhenotypingDataSets5/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv
#CMD python3  Python_Functions/code.py 03_output/converet_airway.csv 01_data/WSAS_AndOLIN_AirwayDiseasePhenotyping.csv

CMD snakemake Results/result_airway_DEC.csv




# docker run -it --rm -v ~/Documents/Data/Airway_Clustering/Original_Data/AirwayDiseasePhenotypingDataSets5:/01_data -v ~/Documents/Data/Airway_Clustering/Results:/Results 690c9cce9b3c

# docker run -it --rm --name newone rani/airway_image:latest bash
