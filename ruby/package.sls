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
  pkg.installed:
    - names:
      - {{ ruby.package }}
      - {{ ruby.package_bundler }}
      - ruby-switch
    - require:
      - pkgrepo: ruby-ppa

  cmd.run:
    - name: ruby-switch --set {{ ruby.package }}
    - require:
      - pkg: ruby

{% elif grains['os_family'] == 'RedHat' %}
# TODO: Test me!
ruby:
  pkg.installed:
    - names:
      - {{ ruby.package }}
      - {{ ruby.package_bundler }}

{% endif %}
