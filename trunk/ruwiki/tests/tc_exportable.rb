#!/usr/bin/env ruby
#--
# Ruwiki version 0.8.0
#   Copyright � 2002 - 2004, Digikata and HaloStatue
#   Alan Chen (alan@digikata.com)
#   Austin Ziegler (ruwiki@halostatue.ca)
#
# Licensed under the same terms as Ruby.
#
# $Id$
#++

if __FILE__ == $0
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib")
  class Ruwiki; end
end

require 'ruwiki/exportable'
require 'test/unit'

  class TCExportable < Test::Unit::TestCase
    class Exportable
      include Ruwiki::Exportable

      attr_accessor :a, :b, :long_name, :altname, :xform, :group2
      exportable :a
      exportable :long_name
      exportable :altname,  :name => 'alt-name'
      exportable :xform, :transforms => [ :to_f ]
      exportable :group2, :group => 'group2'
    end

    def test_exportable
      __exportables = {
        nil => {
          'a'         => ['@a'.intern, nil],
          'long-name' => ['@long_name'.intern, nil],
          'alt-name'  => ['@altname'.intern, nil],
          'xform'     => ['@xform'.intern, [:to_f]],
        },
        'group2' => {
          'group2'    => ['@group2'.intern, nil]
        }
      }
      __values = {
        'a'         => 'a',
        'long-name' => 'c',
        'xform'     => 3.0,
        'alt-name'  => 'd',
        'group2'    => { 'group2' => 'e' }
      }
      xx = nil
      ss = nil
      assert_nothing_raised do
        xx = Exportable.new
        xx.a = "a"
        xx.b = "b"
        xx.long_name = "c"
        xx.altname = "d"
        xx.xform = 22/7
        xx.group2 = "e"
        ss = xx.export
      end
      assert_equal(__exportables, xx.class.__exportables)
      assert_equal(__values, ss)
    end
  end
