from __future__ import division
import os
import glob
import random
import csv

def get_subject_ids(site):
    """Returns list of subject IDs over all sites in ADHD-200 Sample"""
    return [subject for subject in os.listdir(site)
            if os.path.isdir(os.path.join(site, subject))]

def assign_images(subjects, n_raters, n_ratings=3):
    """Assigns images to QA raters as evenly as possible"""

    to_rate = subjects * n_ratings
    random.shuffle(to_rate)
    n_images = len(to_rate)

    avg_ratings = n_images / n_raters
    assignments = []
    last = 0
    while last < n_images:
        assignments.append(to_rate[int(last):int(last+avg_ratings)])
        last += avg_ratings
        
    return assignments


if __name__ == '__main__':
    raters = ['james', 'caroline', 'amalia', 'ben', 'john']
    random.shuffle(raters)

    # This assumes you're in a directory with the following subdirectories:
    # ['Peking_3/', 'OHSU/', 'NeuroIMAGE/', 'Peking_2/', 'Pittsburgh/', 
    # 'WashU/', 'KKI/', 'NYU_1/', 'NYU_2/', 'NYU_4/', 'NYU_3/', 
    # 'Peking_1/', 'Brown/']
    sites = glob.glob('*/')

    subjects = []
    for site in sites:
        subjects.extend(get_subject_ids(site))

    assignments = assign_images(subjects, n_raters=len(raters))

    for i, rater in enumerate(raters):
        with open('{0}.txt'.format(rater), 'w') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_ALL, delimiter='\n')
            writer.writerow(assignments[i])