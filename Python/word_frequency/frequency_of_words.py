words_l = ["apple","banana","apple","orange","banana","apple","grape","banana","banana","orange"]

words_nl = list(set(words_l))

for word in words_nl:
    count = 0 
    for word2 in words_l:
        if word == word2:
            count = count + 1
    print(word, count)