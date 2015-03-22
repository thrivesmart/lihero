// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var NewLead = {
  persons: null,
  companies: null,
  init: function() {
    this.persons = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('lead_search_query'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/linkedin/people.json?q=%QUERY'
    });

    this.companies = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('lead_search_query'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/linkedin/companies.json?q=%QUERY'
    });

    this.persons.initialize();
    this.companies.initialize();

    $('#lead_search_query.typeahead').typeahead({
      highlight: true
    },
    {
      name: 'persons',
      displayKey: 'persons',
      source: this.persons.ttAdapter(),
      templates: {
        header: '<h3 class="kind">People</h3>'
      }
    },
    {
      name: 'companies',
      displayKey: 'companies',
      source: this.companies.ttAdapter(),
      templates: {
        header: '<h3 class="kind">Companies</h3>'
      }
    });
  }
};

if ($('#lead_search_query').get(0)) {
	NewLead.init();
}