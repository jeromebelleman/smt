#!/usr/bin/env python
# coding=utf-8

import os
from distutils.core import setup

delattr(os, 'link')

setup(
    name='smt',
    version='1.0',
    author='Jerome Belleman',
    author_email='Jerome.Belleman@gmail.com',
    url='http://cern.ch/jbl',
    description="Check if SMT is on",
    long_description="Check whether SMT is enabled on this host.",
    scripts=['smt'],
    data_files=[],
)
