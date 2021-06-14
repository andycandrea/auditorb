Auditorb

---

Auditorb provides a way to audit a Ruby repository.

Auditorb is not currently available via Rubygems. To install, clone this
repository and set it up as a local dependency of the project you would like to
audit like in the following example:

```rb
group :development do
  gem 'auditorb', path: '../auditorb'
end
```

Once installed, you can run each of the audits in sequence via:

```sh
bundle exec auditorb all
```

If you wish to run a specific audit rather than all of them, you can replace
`all` with the name of your desired audit. See [cli.rb](./lib/auditorb/cli.rb)
for a list of available audits.
