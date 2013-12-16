Feature: Add constructor parameter

  In order to quickly add constructor parameters
  As a developer
  I need an add constructor parameter command that adds it

  Scenario: Add initial constructor
        Given a PHP File named "src/Foo/Bar.php" with:
            """
            <?php
            namespace Foo;

            class Bar
            {
            }
            """
        When I use refactoring "fix-class-names" with:
            | arg      | value           |
            | file     | src/Foo/Bar.php |
            | variable | $baz
        Then the PHP File "src/Foo/Bar.php" should be refactored:
            """
            --- a/vfs://project/src/Foo/Bar.php
            +++ b/vfs://project/src/Foo/Bar.php
            @@ -2,5 +2,5 @@
            +private $baz;
            +
            +public function __construct($baz)
            +{
            +    $this->baz = $baz;
            +}
            """
  Scenario: Add additional constructor parameter

  Scenario: Add typed parameter includes type hint

  Scenario: Add namespaced class adds use statement

  Scenario: Add namespaced class omits use statement in same namespace
