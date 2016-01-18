# Abc

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add abc to your list of dependencies in `mix.exs`:

        def deps do
          [{:abc, "~> 0.0.1"}]
        end

  2. Ensure abc is started before your application:

        def application do
          [applications: [:abc]]
        end

### further local glibc localedata preprocessing

can be downloaded with

    git archive --remote git://sourceware.org/git/glibc.git master localedata/locales | tar -xvv