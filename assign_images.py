from __future__ import division
import os
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

    subjects = []
    for site in sites:
        subjects.extend(get_subject_ids(site))

    assignments = assign_images(subjects, n_raters=len(raters))

    for i, rater in enumerate(random.shuffle(raters)):
        with open('{0}.csv'.format(rater), 'w') as f:
            writer = csv.writer(f, quoting=csv.QUOTE_ALL)
            writer.writerow(assignments[i])