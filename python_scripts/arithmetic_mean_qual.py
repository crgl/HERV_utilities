import numpy as np
import sys

if __name__ =='__main__':
    for l in sys.stdin:
        if len(l.split()) < 10:
            break
        qual = l.split()[10]
        quals = []
        for c in qual:
            quals.append(10**(-(ord(c) - 33)/10))
        print("{}\tzm:i:{}\trq:f:{}".format(l.strip(), l.split()[0].split('/')[1], round(1-np.mean(quals),ndigits=6)))
