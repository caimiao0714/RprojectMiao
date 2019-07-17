x = c("I70.0, I70.1, I70.209, I70.219, I70.229, I70.25, I70.269, 
      I70.299, I70.399, I70.499, I70.599, I70.8, I70.90, I70.91, I70.92")

t = strsplit(x, split = ", ") %>% 
  unlist() %>% 
  gsub(pattern = "\\n| ", replacement = "")

paste(sort(t[!duplicated(t)]), collapse = ", ")
  

