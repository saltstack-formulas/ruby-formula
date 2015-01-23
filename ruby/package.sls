{% from "ruby/map.jinja" import ruby with context %}

{% if grains['os_family'] == 'Debian' %}

# TODO: Replace me with ?include apt.ppa?
ruby-ppa:
  pkg.installed:
    - name: python-software-properties

  pkgrepo.managed:
    - ppa: brightbox/ruby-ng
    - refresh: True
    - require:
      - pkg: ruby-ppa

ruby:
  cmd.run:
    - name: ruby-switch --set {{ ruby.package }}
    - require:
      - pkg: ruby

  pkg.installed:
    - names:
      - {{ ruby.package }}
      - ruby-switch
    - require:
      - pkgrepo: ruby-ppa

{% elif grains['os_family'] == 'RedHat' %}
# TODO: Test me!
ruby:
  pkg.installed:
    - names:
      - {{ ruby.package }}
      - {{ ruby.bundler }}

{% endif %}
