# FROM tpgentry/aws-lambda-ruby-arrow:latest
FROM public.ecr.aws/lambda/ruby:latest

# Gems ########################################################################

# Remove existing bundled rubygems
# RUN rm -rf .bundle/
# RUN rm -rf vendor/

# Copy Gemfile from host into container's current directory
COPY Gemfile .
COPY Gemfile.lock .

RUN yum install -y clang make git-core && \
    gem update bundler && \
    bundle config --local silence_root_warning true && \
    bundle config --local path 'vendor/bundle' && \
    bundle config set --local clean 'true' && \
    bundle

# Set up code and entrypoint ##################################################

# Copy function code
COPY filesystem_paths.yml .
COPY lambda_function.rb .
COPY safe_dir.rb .
COPY standard_mappings.yml .

CMD ["lambda_function.LambdaFunction.process"]
# ENTRYPOINT "/bin/bash"
# CMD
