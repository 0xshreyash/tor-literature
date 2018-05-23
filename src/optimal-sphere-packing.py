import numpy as np
from qcqp import *
from cvxpy import *
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import timeit


def main(*args, **kwargs):
    start = timeit.timeit()
    n = args[0] # number of circles
    print("--------", "starting:", n, "--------")
    X = Variable(3, n)
    B = 1
    r = Variable()
    obj = Maximize(r)
    cons = [X >= r, X <= B-r, r >= 0]
    for i in range(n):
        for j in range(i+1, n):
            cons.append(square(2*r) <= sum_squares(X[:, i]-X[:, j]))

    prob = Problem(obj, cons)
    qcqp = QCQP(prob)

    qcqp.suggest(SDR)

    print("SDR-based upper bound: %.3f" % qcqp.sdr_bound)

    f_cd, v_cd = qcqp.improve(COORD_DESCENT)
    print("Coordinate descent: objective %.3f, violation %.3f" % (f_cd, v_cd))
    print("---------------------------------")
    end = timeit.timeit()


    return f_cd, v_cd, end - start

if __name__ == '__main__':
    print(list(map(main, [2, 6, 10, 20, 30, 40, 50])))
