import requests
from bs4 import BeautifulSoup


headers={
    'authority': 'www.icd10data.com',
    'method': 'GET',
    'path': '/Convert/36.03',
    'scheme': 'https',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
    'accept-encoding': 'gzip, deflate, br',
    'accept-language': 'zh-CN,zh;q=0.9',
    'cache-control': 'max-age=0',
    'cookie': '_ga=GA1.2.1086716260.1563868202; _gid=GA1.2.1478799181.1563868202; __hstc=93424706.6b6b93f18691ef5d9414641b440bdd8c.1563868411367.1563868411367.1563868411367.1; hubspotutk=6b6b93f18691ef5d9414641b440bdd8c; __hssrc=1; __hssc=93424706.4.1563868411367',
    'upgrade-insecure-requests': '1',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36',
}

def get_code(url):

    req=requests.get(url,headers=headers,timeout=50)
    bsObj=BeautifulSoup(req.text,'html.parser')
    ul=bsObj.find('ul',class_='ulConversion')#取出ul
    li_list=ul.find_all('li')#取出li列表

    f=open('icd_10_pcs.txt','a+',encoding='utf-8')#打开txt文件，每次都清空，重新写入

    for li in li_list:
        a=li.find('a')
        alt=a.attrs['alt']
        pcs=alt.split(' ')[-1]
        print(pcs)
        f.write(pcs+'\n')
    f.close()
    
url_list=['https://www.icd10data.com/Convert/36.03',]

for url in url_list:
    get_code(url)