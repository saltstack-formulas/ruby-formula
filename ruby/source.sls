{% set ruby = pillar.get('ruby', {}) -%}
{% set version = ruby.get('version', '2.2.0') -%}
{% set source_url = ruby.get('source_url', 'http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz') -%}
{% set checksum = ruby.get('source_checksum', 'md5=cd03b28fd0b555970f5c4fd481700852') -%}
{% set source = ruby.get('source_root', '/usr/local/src') -%}

{% set ruby_package = source + '/ruby-' + version + '.tar.gz' -%}


# Other os_families than Debian are untested.
# List is from: https://github.com/sstephenson/ruby-build/wiki
# TODO: Test RedHat variant
{% if grains['os_family'] == 'Debian' -%}
ruby_source_installer_packages:
  pkg.installed:
    - names:
      - autoconf # Not sure these two are needed.
      - bison
      - build-essential
      - zlib1g-dev
      - libyaml-dev
      - libssl-dev
      - libreadline-dev
      - libcurl4-openssl-dev
      - libxml2-dev
      - libxslt1-dev
      - libreadline6-dev
      - libncurses5-dev
      - libffi-dev
      - libgdbm3
      - libgdbm-dev
{% elif grains['os_family'] == 'RedHat' -%}
ruby_source_installer_packages:
  pkg.installed:
    - names:
      - gcc
      - openssl-devel
      - libyaml-devel
      - libffi-devel
      - readline-devel
      - zlib-devel
      - gdbm-devel
      - ncurses-devel
{% endif -%}

get_ruby:
  file.managed:
    - name: {{ ruby_package }}
    - source: {{ source_url }}
    - source_hash: {{ checksum }}
  module.run:
    - name: archive.tar
    - cwd: {{ source }}
    - tarfile: {{ ruby_package }}
    - options: zxf
    - require:
      - pkg: ruby_source_installer_packages
    - watch:
      - file: get_ruby

ruby:
  cmd.wait:
    - cwd: {{ source + '/ruby-' + version }}
    - name: ./configure && make && make install
    - watch:
      - module: get_ruby
    - require:
      - pkg: old_ruby_purged