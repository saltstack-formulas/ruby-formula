{% from "ruby/map.jinja" import ruby with context %}

{% if grains['os_family'] == 'Debian' %}

ruby_repo:
  pkgrepo.managed:
    - humanname: ruby-ppa-{{ grains['oscodename'] }}
    - name: deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/ruby-{{ grains['oscodename'] }}.list
    - dist: {{ grains['oscodename'] }}
    - keyid: C3173AA6
    - keyserver: keyserver.ubuntu.com

ruby:
  pkg.installed:
    - names:
      - {{ ruby.package }}
      - {{ ruby.package_bundler }}
      - ruby-switch
    - require:
      - pkgrepo: ruby_repo

  cmd.run:
    - name: ruby-switch --set {{ ruby.package }}
    - require:
      - pkg: ruby

{% elif grains['os_family'] == 'RedHat' %}
ruby:
  pkg.installed:
    - names:
      - {{ ruby.package }}

  cmd.run: 
    - name: gem install {{ ruby.package_bundler }}

{% endif %}
