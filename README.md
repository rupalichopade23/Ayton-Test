# Test

[![GitHub](https://img.shields.io/badge/github-sentiampc%2Ftest--halloumi-blue.svg)](https://github.com/sentiampc/test-halloumi)

_If you are not already reading YARD generated documentation, you can read the
full documentation by first generating it by running `bundle exec rake yard` and
then opening the generated `doc/index.html` document in your favorite browser._

## Synopsis

Halloumi project for Test.

## 1. Local development

Install dependencies

    bundle config build.rugged --use-system-libraries
    bundle config build.nokogiri --use-system-libraries
    bundle install

## 2. Add a `~/.env.private` file

Add the following environment variables

    LS_AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXXXX
    LS_AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXX
    LS_AWS_MFA_SERIAL=arn:aws:iam::############:mfa/XXXXXX
    AWS_ROLE=XXXXXXX

## 3. Customize the deployment

 1. Update the `.env.test` file.

        AWS_ACCOUNT = ############
        AWS_REGION = XXXXXXXX
        STACK_NAME = XXXXXXXXXXXXX
        CLOUDFORMATION_BUCKET = XXXXXXXXXXXXXXXXXXXXXXXX

 2. Adapt the `.env` file for the deployment.

        ENVIRONMENT = test

## 4. Deploy Stack

    bundle exec rake && bundle exec rake apply

## 5. Run tests, inspect template changes, and deploy

    bundle exec rake
    bundle exec rake diff
    bundle exec rake apply

## 6. Delete Stack

    bundle exec rake delete

# Environment Variable Reference

Environment variables are loaded in the following order, once a variable has
been set it will not be overwritten:

  * Variables you pass when calling `rake`
  * Variables defined in your current shell environment
  * Variables defined in `~/.env.private`
  * Variables defined in `.env.private`
  * Variables defined in `.env.*.ami`
  * Variables defined in `.env`
  * Variables defined in `.env.$ENVIRONMENT`

Please define deployment specific variables in `.env.xxxx` files.
You MUST keep secrets outside versionning, for that, use a `.env.private` file,
and store a safe copy of this file in a password manager like 1Password or
LastPass.

## User-Defined

### `AWS_ACCOUNT`
The Amazon Web Services account ID, a 12 digit long number, please remove the
 dashes.

### `AWS_REGION`
The Amazon Web Services region to deploy the stack.

### `SHARED_AMI_OWNERS`
The Amazon Web Services account ids that should have access to build ami"s.

### `MANAGEMENT_SUBNETS`
A whitespace and/or comma separated list of IPv4 IPs or CIDRs, for example
`37.17.210.74, 1.2.3.4 5.6.7.8/28`. Only enable this when needed!

### `PACKER_BUILD_SCRIPT`
Used by Packer to determine which script from `packer/src` to use in order to
build the AMI.

### `SOURCE_AMI`
The ID of the AMI to use as base image for Packer.

### `STACK_NAME`
The name of the stack. Used when applying/deleting the stack.

## Automatically Set

### `DEPLOYMENT_GIT_COMMIT`
The GIT commit ID of the current HEAD of the deployment project, a.k.a. the
super-project.

### `GIT_COMMIT`
The GIT commit ID of the current HEAD of a packer project.
