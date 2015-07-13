include:
  - ruby

{% from "ruby/map.jinja" import ruby with context %}

{% if ruby.install_from_source %}
ruby-dev:
  test.succeed_without_changes:
    - name: ruby-dev

{% else %}
ruby-dev:
  pkg.installed:
    - names:
      - {{ ruby.package_dev }}
    - require:
      - pkg: ruby
{% endif %}