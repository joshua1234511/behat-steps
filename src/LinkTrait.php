<?php

namespace DrevOps\BehatSteps;

/**
 * Trait LinkTrait.
 *
 * @package DrevOps\BehatSteps
 */
trait LinkTrait {

  /**
   * Assert presence of a link with a href.
   *
   * Note that simplified wildcard is supported in "href".
   *
   * @code
   * Then I should see the link "About us" with "/about-us"
   * Then I should see the link "About us" with "/about-us" in ".main-nav"
   * Then I should see the link "About us" with "/about*" in ".main-nav"
   * @endcode
   *
   * @Then I should see the link :text with :href
   * @Then I should see the link :text with :href in :locator
   */
  public function linkAssertTextHref($text, $href, $locator = NULL) {
    /** @var \Behat\Mink\Element\DocumentElement $page */
    $page = $this->getSession()->getPage();

    if ($locator) {
      $element = $page->find('css', $locator);
      if (!$element) {
        throw new \Exception(sprintf('Locator "%s" does not exist on the page', $locator));
      }
    }
    else {
      $element = $page;
    }

    $link = $element->findLink($text);
    if (!$link) {
      throw new \Exception(sprintf('The link "%s" is not found', $text));
    }

    if (!$link->hasAttribute('href')) {
      throw new \Exception('The link does not contain a href attribute');
    }

    $pattern = '/' . preg_quote($href, '/') . '/';
    // Support for simplified wildcard using '*'.
    $pattern = strpos($href, '*') !== FALSE ? str_replace('\*', '.*', $pattern) : $pattern;
    if (!preg_match($pattern, $link->getAttribute('href'))) {
      throw new \Exception(sprintf('The link href "%s" does not match the specified href "%s"', $link->getAttribute('href'), $href));
    }
  }

  /**
   * @Then the link with title :title exists
   */
  public function linkAssertWithTitle($title) {
    $title = $this->linkFixStepArgument($title);

    $item = $this->getSession()->getPage()->find('css', 'a[title="' . $title . '"]');

    if (!$item) {
      throw new \Exception(sprintf('The link with title "%s" does not exist.', $title));
    }

    return $item;
  }

  /**
   * @Then the link with title :title does not exist
   */
  public function linkAssertWithNoTitle($title) {
    $title = $this->linkFixStepArgument($title);

    $item = $this->getSession()->getPage()->find('css', 'a[title="' . $title . '"]');

    if ($item) {
      throw new \Exception(sprintf('The link with title "%s" exists, but should not.', $title));
    }
  }

  /**
   * @Then I click the link with title :title
   */
  public function linkClickWithTitle($title) {
    $link = $this->linkAssertWithTitle($title);
    $link->click();
  }

  /**
   * Returns fixed step argument (with \\" replaced back to ").
   */
  protected function linkFixStepArgument($argument) {
    return str_replace('\\"', '"', $argument);
  }

}
