console.log('js main loading')
$(document).ready(function(){

  // Invoke desktop table sortability
  // if ($('table.candidates').length > 0) {
  //   $('table.candidates').DataTable( {
  //     paging:   false,
  //     // ordering: false,
  //     info:     false,
  //     searching: false
  //   });
  // }
  var lastParentRowData;
  $('button#donation-dummy-submit').on('click', function(){

    console.log("form#donation-dummy-submit clicked so actually submitting form");
    $('form#new_tweet').submit();
  });

  $('form#new_tweet').on('submit', function(e){
    e.preventDefault();
    console.log("form#new_tweet submit event");
    var form = $(this);

    $.ajax({
      type: "POST",
      url: form.attr('action'),
      data: form.serialize(),
      success: function(data)
      {
        console.log('yay, form submitted via ajax, i think'); // show response from the php script.

        $('#donation-modal').modal('hide');

        // clear from values for next tweet
        $('form#new_tweet #tweet_text').val('');
        $('form#new_tweet input#donation-id-input').val('placeholder');

      }
    });

    // e.preventDefault();



    // $(this).submit();
    // e.preventDefault();
  });

  $('#donation-modal').on('show.bs.modal', function (e) {
    // udpate form donation id value
    console.log('show modal event');
    var clickedTweetId = $(e.relatedTarget).data('donationId');
    $('form#new_tweet input#donation-id-input').val(clickedTweetId);

    // find the data table row

    var donationTable = $(e.relatedTarget.closest('table')).DataTable();
    
    var donationRow = donationTable.row(e.relatedTarget.closest('tr'));

    // TODO this is ugly for now but Datatables doesn't look like it has a great way of grabbing parent row

    var $candidateRow = $(donationRow.node()).closest('table').closest('tr').prev();
    var candidateData = candidatesTable.row($candidateRow).data();
    
    var donationRowData = donationRow.data();

    var tweetText = "Let's congratulate " + candidateData.twitter_handle + " on a 'donation' of $" + donationRowData.amount + " from " + s.titleize(donationRowData.first_name) + " " + s.titleize(donationRowData.last_name) + " of " + s.titleize(donationRowData.employer) + ".";

    // prefill tweet
    $('form#new_tweet textarea#tweet_text').val(tweetText);


  });

  $('.twitter-icon').on('click', function(){
    console.log('twitter-icon clicked');
  });
  
  var donationsTable = $('table.donations');

  var candidatesTable = $('#candidates-table').DataTable( {
      paging:   false,
      // ordering: false,
      info:     false,
      searching: false,
      columns: [
        null,
        {data: "last_name"},
        {data: "first_name"},
        {data: "chamber"},
        {data: "party"},
        {data: "state"},
        {data: "district"},
        {data: "total_donations"},
        {data: "twitter_handle"}
      ]

  } );

  var cellMaker = function(text){
    return "<td>" + text + "</td>";
  };
  // Add event listener for opening and closing details
  $('#candidates-table tbody').on('click', 'td.expand-donations', function () {
      var td = $(this);
      var tr = $(this).closest('tr');
      var row = candidatesTable.row( tr );

      if ( row.child.isShown() ) {
        // This row is already open - close it
        console.log('showing so hiding');
        td.text('+');
        row.child.hide();
        tr.removeClass('shown');
      }
      else {
        
        td.text('-');
        donations_path = "candidates/" + $(this).data('candidateId') + "/donations";

        $.ajax(donations_path, {
          success: function(data) {
            console.log('data', data);

            var clonedTable = donationsTable.clone();
            data.forEach(function(donation){

              clonedTable.find('tbody').append( "<tr>" + cellMaker(donation.amount) + cellMaker(donation.date) + cellMaker(donation.last_name) + cellMaker(donation.first_name) + cellMaker(donation.employer) + cellMaker(donation.occupation) + cellMaker(donation.state) + cellMaker(donation.city) + cellMaker(donation.fec_record_num) + "<td class='twitter-icon' data-toggle='modal' data-target='#donation-modal' data-donation-id='" + donation.id + "'></td>" + cellMaker(donation.tweet_count)+ "</tr>");

            });
            




            // Open this row
            console.log('hidden so showing');
            clonedTable.removeClass('hidden');
            row.child( clonedTable ).show();
            tr.addClass('shown');

            clonedTable.DataTable( {
                paging:   false,
                info:     false,
                searching: false,
                order: [[0, 'desc']],
                // define column names so have access to data object later
                columns: [
                  {data: "amount"},
                  {data: "date"},
                  {data: "last_name"},
                  {data: "first_name"},
                  {data: "employer"},
                  {data: "occupation"},
                  {data: "state"},
                  {data: "city"},
                  {data: "fec_record_num"},
                  null,
                  {data: "tweet_count"}
                ]

                // columnDefs: [
                //   {className: "twitter-icon", "targets":[9]}
                // ]
                // "ajax": "../ajax/data/objects.txt",
                // "columns": [
                //     {
                //         "className":      'expand-donations',
                //         "orderable":      false,
                //         "data":           null,
                //         "defaultContent": ''
                //     },
                //     { "data": "name" },
                //     { "data": "position" },
                //     { "data": "office" },
                //     { "data": "salary" }
                // ],
                // "order": [[1, 'asc']]
            } );

            // $('#main').html($(data).find('#main *'));
            // $('#notification-bar').text('The page has been successfully loaded');
          },
          error: function() {
            console.log('error');
          }
        });

      }
  } );


});