# Run with
#   make grade s=DIR n=MILESTONE-NUMBER
# where DIR is the current subdirectory that holds the student's work:
# e.g.,
#   make grade s=sq/s1
# for now `grade` is the default target, so
#   make s=sq/s1
# suffices

# Grade with reasonable simulation of Gradescope's script setup
grade:
	rm -rf autograder
	mkdir autograder/
	mkdir autograder/results/
	#
	# docker run -ti -v `pwd`/autograder:/autograder -v `pwd`/$(s):/autograder/submission ubuntu-racket /bin/bash
	docker run -ti \
		-v `pwd`/tests/$(s):/autograder/submission \
		-v `pwd`/autograder/results:/autograder/results \
		cpsc411-gradescope-m$(n) /autograder/run_autograder
	printf "\n\n"
	cat autograder/results/results.json
	printf "\n\n"

grade.rkt: grade_milestone_$(n).rkt
	cp $< $@
	touch `ls grade_milestone_*.rkt | grep -v $<`

base-image:
	docker build -f Dockerfile.base-image -t gradescope-racket-base .

grader-image: grade.rkt
	docker build -f Dockerfile.grader-image -t cpsc411-gradescope-m$(n) .

zip: milestone-$(n).zip

milestone-$(n).zip: grade.rkt
	rm -rf setup.sh
	echo '#!/bin/bash' > setup.sh
	echo 'cd /autograder/source' > setup.sh
	tail -n +2 Dockerfile.base-image | sed "s/COPY/foo cp/" | grep -v "ADD" | cut -f 2- -d ' ' >> setup.sh
	zip -r $@ setup.sh ssh_config id_cpsc411-deploy-key run_autograder grade.rkt lib-grade.rkt

