import cv2
import os
import scipy.misc
import argparse
import numpy as np


def main(query, results):
    que = cv2.imread(query)
    ret = [cv2.imread(image) for image in results]
    combResult = np.zeros([que.shape[0], que.shape[1] * 2, que.shape[2]])
    resizedRet = [scipy.misc.imresize(image, 1/2., mode='RGB') for image in ret]
    print(resizedRet[0].shape[0], resizedRet[0].shape[1])
    combResult[0:que.shape[0], 0:que.shape[1], :] = que
    combResult[0:que.shape[0] // 2, que.shape[1]:int(que.shape[1] * 1.5), :] = resizedRet[0]
    combResult[0:que.shape[0] // 2, int(que.shape[1] * 1.5):que.shape[1] * 2, :] = resizedRet[1]
    combResult[que.shape[0] // 2:que.shape[0], que.shape[1]:int(que.shape[1] * 1.5), :] = resizedRet[2]
    combResult[que.shape[0] // 2:que.shape[0], int(que.shape[1] * 1.5):que.shape[1] * 2, :] = resizedRet[3]
    cv2.imwrite('image.jpg', combResult)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--query', type=str, metavar='PATH', required=True)
    parser.add_argument('--firstResult', type=str, metavar='PATH', required=True)
    parser.add_argument('--secondResult', type=str, metavar='PATH', required=True)
    parser.add_argument('--thirdResult', type=str, metavar='PATH', required=True)
    parser.add_argument('--fourthResult', type=str, metavar='PATH', required=True)

    args = parser.parse_args()
    query = args.query
    results = [args.firstResult, args.secondResult, args.thirdResult, args.fourthResult]

    main(query, results)