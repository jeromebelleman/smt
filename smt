#! /usr/bin/env python

'''
Check if SMT is enabled on this host
'''

import sys
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter

UNEXPECTED = "Unexpected siblings/cpu cores configuration"

def main():
    '''
    Main
    '''

    parser = ArgumentParser(description="Check if SMT is enabled on this host.",
                            formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument('-v', '--verbose', action='store_true',
        help="print message as to whether SMT is enabled or not")
    parser.add_argument('--cpuinfo', help="cpuinfo file path",
                        default='/proc/cpuinfo')
    args = parser.parse_args()

    try:
        with open(args.cpuinfo) as fhl:
            smt = None
            for i, line in enumerate(fhl, 1):
                if 'siblings' in line:
                    _, _, val = line.split()
                    siblings = int(val)

                if 'cpu cores' in line:
                    _, _, _, val = line.split()
                    cpucores = int(val)

                    if siblings > cpucores and (smt is None or smt == 0):
                        smt = 0
                    elif siblings == cpucores and (smt is None or smt == 1):
                        smt = 1
                    else:
                        raise ValueError(UNEXPECTED)
    except ValueError, exc:
        print >> sys.stderr, "line %d: %s" % (i, exc)
        return 2
    except IOError, exc:
        print >> sys.stderr, exc
        return 2

    if args.verbose:
        print "SMT is %s on this host" % ('enabled' if smt == 0 else 'disabled')
    return smt

if __name__ == '__main__':
    sys.exit(main())
