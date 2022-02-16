# Auto-Grading CPSC411 Racket Code in Gradescope

Forked from https://github.com/shriram/gradescope-racket.
Most of the documentation from the original remains, although some has been
replaced, and some new features have been added.

In particular:

- Docker cache invalidation from updating public course infrastructure repository.
- Dynamic input to the Makefile to choose grader script.
- Private repository access in Docker and GradeScope setup script.
- Support for test suite names in GradeScope output.
- Support for missing test names.

# Instructions and Documentation

This repository enables educators to autograde student submissions from CPSC 411
written in [Racket](https://racket-lang.org/) on [Gradescope](https://www.gradescope.com/).
The structure may be useful or serve as an example for other wishing to grade
submissions on GradeScope.

The current structure allows multiple assignments (milestones) to exist
simultaneously in the same repository, and an input environment variable `n` to
the Makefile to select between them.

## Examples

The directory `tests/milestone-1-skeleton/` contains skeleton submissions of a
`milestone-1` submission for CPSC 411, and `grade_milestone_1.rkt` a test
suite for it. To install that test suite, then check the several mock
submissions:
```
make grader-image n=1
make s=milestone-1-skeleton
make s=milestone-1-ref
```
Focus on the JSON output at the end of these runs.
Each `ref` test (assuming you have the reference solution installed) should pass all tests.
Each `skelestone` test should fail most of the tests.

## Deploying to Gradescope

Run `make zip n=<milestone-number>` to generate the Zip file that you upload to
Gradescope. If you have broken your grader into multiple files, be
sure to edit the Makefile to add those other files to the archive as
well. (And don't forget to add them to the repository, too!)

Following Gradescope's instructions (see below), upload the Zip.

Gradescope will build a Docker image for you.

When it's ready, you can upload sample submissions and see the output
from the autograder.

## Docker

Gradescope relies on Docker. You don't strictly have to know how to
use Docker yourself, but it certainly helps.

If you're not comfortable with Docker, you can just create the test
suite (see below), upload files to Gradescope, and leave the building
to them, and test on their machines. Be aware this can be quite slow,
and if you make a mistake, you'll have to do it all over again.

Assuming you will use Docker locally:

1. Make a local image for testing:
```
make base-image
make grader-image n=<milestone-number>
```
   There are two images due to staging. The first installs Racket and various
   dependencies common to all autograders, but the second installs the
   assignment-specific grader content, which is likely to change quite
   a bit as you're developing it. The base-image uses the GitHub API to detect
   updates to course dependencies that might change, and invalidate the Docker
   cache. We don't have to name both images, but it might make it a bit clearer
   to navigate (and it's sometimes also useful to go into a pristine
   `base-image` to test some things).
   The grader image requires a milestone number as input, `<milestone-number>`,
   since grader files differ from milestone to milestone.

2. When you're ready to test, run `make grade n=<milestone-number> s=<dir>`,
where `<dir>` is the sub-directory of `tests` that houses the (mock) student
submission, and `<milestone-number>` is a milestone number. See examples below.

## Configuring Private Repo Access in Grader
The CPSC 411 graders expect to have access to private repositories.
The Docker grader image and setup script expect a private deploy key,
`id_cpsc411-deploy-key`, to be present in the repository and to provide access
to private repositories.
This private key is configured in the Docker image and GradeScope setup script
using `ssh_config`, and is configured to be ignored.

## Creating a Test Suite

The library currently depends on `rackunit`. If you're only used to
the student language levels, don't worry, it's pretty similar. Stick
to the `test-*` forms (as opposed to the `check-*` ones). You can read
up more
[in the documentation](https://docs.racket-lang.org/rackunit/api.html).

**Warning**: Use _only_ the `test-` forms, **not** the `check-` forms!
The former work well in the presence of run-time errors caused by a
check. The latter do not, so one erroneous test can truncate grading.

All test suites are named `grade_milestone_<n>.rkt`, where `<n>` is a milestone
number.
This number is an input to the `Makefile`.
The Makefile will create `grader.rkt` from these when building a grader image or
zip file for GradeScope.

There are three files to help you create your own grader:

- a template file, which doesn't itself work: `grade-template.rkt`
- the graders used for each milestone: `grade_milestone_0.rkt`, `grade_milestone_1.rkt`, and so on.

If you use the template, be sure to edit only the `UPPER-CASE` parts
of it.

Test suite can be nested, so you can add as many test suites as you want.

Once you've created your test suite, you will probably want to test it
locally first. This requires you to have Docker installed (but not
necessarily know much about how to use it). See the instructions
above. If you're skipping local testing, you can move on to deployment.

## Naming Tests

Note that all the `test-*` forms take a *name* for the test. (This is
a difference from the student languages.) To name it wisely, it is
important to understand how this name is used.

When a test fails (either the answer is incorrect, or it has an
error), students get a report of the failure. In the report, they see
the _name_ of the test, rather than the actual test or test
output. This is because both of those can leak the content of the
test. A cunning student can write a bunch of failing tests, and use
those to exfiltrate your test suite, which you may have wanted to keep
private.

Many course staff thus like to choose names that are instructive
to the student for fixing their error, but do not give away the whole
test. If, on the other hand, you want students to know the full test,
you could just write that in the test. For instance, assuming you are
testing a `sq` function that squares its input, your could write any
of these, from least to most informative:
```
  (test-equal? "" (sq -1) 1)
  (test-equal? "a negative number" (sq -1) 1)
  (test-equal? "-1" (sq -1) 1)
```

Test suites can also have names.
For example:
```
(test-suite
  "Test suite 1"
  (test-equal? "" (sq -1) 1))
```

When names are reported to suites, the names of test suites and their tests are
appended hierarchically.
For example, all public milestone 4 tests have "v4 public test suite:" prepended
to the test name.

## Why `define-var`

You might wonder why you have to use `define-var` to name the
variables you want from the module, especially if the module already
exports them. (If you don't use `define-var` you'll get an unbound
identifier error.) There are two reasons:

1. Some languages, like Beginning Student Language, do not export
   names. Therefore, the autograder has to “extract” them from the
   module, and wouldn't know which ones to extract.

2. Simply accepting all the names from a module may be dangerous: a
   malicious student could export names that override the autograder's
   functionality (since this code is public, after all), thereby
   giving themselves they grade they want, not the one they deserve
   (unless it's a course on malicious behavior, in which case, they've
   earned whatever they award).

`define-var` lets you carefully limit which names the student provided
you actually end up with. It will first look for the exported name
and, only if it isn't found, extract from the module. This avoids the
slight nuisance of having to return a student's assignment for having
forgotten to export a name. (If this behavior isn't desired, talk to
me and I can help you edit the source.)

## Why `mirror-macro`

Macros are not values. Therefore, we can't simply extract the macro as
a value from the student's module. Instead, the library sets up a
mirror of that macro in the testing module. Note that it currently has
the following consequences (some are weaknesses, others aren't as clear):

- All evaluation happens in the student's module. Thus, all references
  to names are resolved in that module. This means a local helper
  function cannot be referenced directly.

- Because of the way `mirror-macro` is written, the mirroring step
  takes place each time a test *uses* a macro. This does not seem to
  be prohibitively costly, but it is at least annoying. If this proves
  to be a performance problem, let me know.

- Because this code goes into the student's module, it uses the
  namespace local to that module, not the names exported. Practically
  speaking, this means it disregards `rename-out` in the student's
  module. Since we don't expect students will be using this feature if
  they are still at the level where this library makes sense, this
  should not be much of a problem.

## Scoring

Gradescope demands that every submission be given a numeric score:
either one in aggregrate or one per test. I find this system quite
frustrating; it imposes a numerics-driven pedagogy that I don't embrace
on many assignments. Therefore, for now the score given for the
assignment is simple: the number of passing tests divided by the total
number of tests. That's it. Someday I may look into adding weights for
tests, etc., but I'm really not excited about any of it. Either way,
please give your students instructions on how to interpret the numbers.

## Is This Current?

This code has been tested with Gradescope in late Feb 15, 2022, using
Racket 8.3. Since Gradescope's APIs are in some flux, you may
encounter errors with newer versions; contact me and I'll try to
help. In addition, Gradescope intends to make it easier to deploy
autograders using Docker; when that happens, it would be nice to
upgrade this system.

This code does not have any non-vanilla-Racket dependencies.

## Gradescope Specs

Gradescope's "specs" are currently at:

<https://gradescope-autograders.readthedocs.io/en/latest/getting_started/>

<https://gradescope-autograders.readthedocs.io/en/latest/specs/>

<https://gradescope-autograders.readthedocs.io/en/latest/manual_docker/>

<https://gradescope-autograders.readthedocs.io/en/latest/git_pull/>

## Acknowledgments

Thanks to Shriram Krishnamurthi, Jason Hemann, Matthew Flatt, Alex Harsanyi,
David Storrs, Alexis King, Matthias Felleisen, Joe Politz, and James Tompkin.
