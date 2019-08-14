# coding=utf-8

import re
def sort_article(filename):
    article_dict={}
    article=''
    key=''    
    for line in open(filename,'r',encoding='utf-8'): 
        if line[0]=='@':
            key=re.search(r'{(.+?),',line).group(1).lower() 
            if key!='' and key not in article_dict.keys():
                article_dict[key]=set()           
        if line.replace('\n','') == '' and article.replace('\n','')!='':#出现空行就发生保持
            article_dict[key].add(article)
            article=''
        article=article+line
    if article.replace('\n','')!='':
        article_dict[key].add(article)
    return sorted(article_dict.items(),key=lambda x:x[0])

def write_to(filename,lst):
    f=open(filename,'w+',encoding='utf-8')
    for item in lst:
        print(item)
        print(item[0])
        f.write('\n\n'.join(list(item[1])))
        # break
    f.close()


filename='example.bib'
art_dict=sort_article(filename)
f='sorted_example.bib'
write_to(f,art_dict)
