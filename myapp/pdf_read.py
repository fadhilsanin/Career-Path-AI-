import csv
import base64,random

import math
import time,datetime
# from pyresparser import ResumeParser
from pdfminer3.layout import LAParams, LTTextBox
from pdfminer3.pdfpage import PDFPage
from pdfminer3.pdfinterp import PDFResourceManager
from pdfminer3.pdfinterp import PDFPageInterpreter
from pdfminer3.converter import TextConverter
# from nltk.corpus import stopwords
#

import io,random



def pdf_reader(file):
    resource_manager = PDFResourceManager()
    fake_file_handle = io.StringIO()
    converter = TextConverter(resource_manager, fake_file_handle, laparams=LAParams())
    page_interpreter = PDFPageInterpreter(resource_manager, converter)
    with open(file, 'rb') as fh:
        for page in PDFPage.get_pages(fh,
                                      caching=True,
                                      check_extractable=True):
            page_interpreter.process_page(page)

        text = fake_file_handle.getvalue()

    # close open handles
    converter.close()
    fake_file_handle.close()
    return text
import re
WORD = re.compile(r'\w+')
from collections import Counter
def text_to_vector(text):
    words = WORD.findall(text)
    return Counter(words)

def get_cosine(vec1, vec2):
    intersection = set(vec1.keys()) & set(vec2.keys())
    numerator = sum([vec1[x] * vec2[x] for x in intersection])
    sum1 = sum([vec1[x] ** 2 for x in vec1.keys()])
    sum2 = sum([vec2[x] ** 2 for x in vec2.keys()])
    denominator = math.sqrt(sum1) * math.sqrt(sum2)
    if not denominator:
        return 0.0
    else:
        return float(numerator) / denominator

def maincode(fpath):
    res=pdf_reader(fpath)
    print(res)
    import csv
    vec1=text_to_vector(res)
    result={}
    oplis=[]
    i=0
    with open(r'C:\Users\U\PycharmProjects\careerpath\myapp\example.csv', mode='r', newline='',encoding='utf-8') as file:
        csv_reader = csv.reader(file)



        for row in csv_reader:
            if i>0:

                vec2=text_to_vector(row[1])
                sim=get_cosine(vec1,vec2)
                if row[0] not in oplis:
                    result[row[0]]=sim
                else:
                    if sim>result[row[0]]:
                        result[row[0]]=sim

            i=i+1
    print("+++++++++++++++++++++++++++++")
    print("+++++++++++++++++++++++++++++")
    print(result)
    print("===========================")
    print("===========================")
    sorted_results = sorted(result.items(), key=lambda item: item[1], reverse=True)
    return sorted_results


def maincode_dsim(fpath,details):
    res=pdf_reader(fpath)
    import csv
    vec1=text_to_vector(res)
    result={}
    oplis=[]
    i=0
    vec2=text_to_vector(details)
    sim=get_cosine(vec1,vec2)
    return sim
# print(maincode(r"C:\Users\U\PycharmProjects\careerpath\media\junior-python-developer2 - Template 16 _KwjSgPr.pdf"))