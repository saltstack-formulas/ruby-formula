include:
  - ruby

{% from "ruby/map.jinja" import ruby with context %}

{% if ruby.install_from_source %}
ruby-passenger:
  test.succeed_without_changes:
    - name: ruby-passenger

{% else %}
ruby-passenger:
  pkg.installed:
    - names:
      - {{ ruby.package_passenger }}
    - require:
      - pkg: ruby
{% endif %}