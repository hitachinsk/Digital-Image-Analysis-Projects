from scipy.io import loadmat
from scipy.io import savemat
from sklearn.cluster import KMeans


def main(path, K):
    data = loadmat(path)
    estimator = KMeans(n_clusters=K).fit(data)
    codeBook = estimator.cluster_centers_
    savemat('/output/codeBook120000.mat', codeBook)

if __name__ == '__main__':
    path = ''
    K = 10000
    main(path, K)
