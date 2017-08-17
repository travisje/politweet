$(document).ready(function(){
  
  /////////////////
  // DONATION MODAL
  /////////////////

  // Modal dummy submit

  var lastDonationTweetCell;

  $('button#donation-dummy-submit').on('click', function(){

    console.log("form#donation-dummy-submit clicked so actually submitting form");
    $('form#new_tweet').submit();
  });

  // Donation modal submit
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

        $('#donation-modal').modal('hide');
        
        // increase tweet count
        lastDonationTweetCell.data( parseInt(lastDonationTweetCell.data()) + 1 ).draw();

        // clear from values for next tweet
        $('form#new_tweet #tweet_text').val('');
        $('form#new_tweet input#donation-id-input').val('placeholder');

      }
    });

  });

  $('#donation-modal').on('show.bs.modal', function (e) {
    
    // udpate form donation_id value to submit correctly

    var clickedTweetId = $(e.relatedTarget).data('donationId');
    $('form#new_tweet input#donation-id-input').val(clickedTweetId);

    // find the data table row

    var donationTable = $(e.relatedTarget.closest('table')).DataTable();
    var donationRow = donationTable.row(e.relatedTarget.closest('tr'));

    // TODO this is ugly for now but Datatables doesn't look like it has a great way of grabbing parent row

    var $candidateRow = $(donationRow.node()).closest('table').closest('tr').prev();
    
    // Grab candidate and donation data for tweet prefill
    var candidateData = candidatesTable.row($candidateRow).data();
    var donationRowData = donationRow.data();

    // Save for incrementing after tweet
    lastDonationTweetCell = donationTable.cell( $(e.relatedTarget.closest('tr')).find('.tweet-count') );

    var tweetText = "Let's congratulate " + candidateData.twitter_handle + " on a 'donation' of $" + donationRowData.amount + " from " + s.titleize(donationRowData.first_name) + " " + s.titleize(donationRowData.last_name) + " of " + s.titleize(donationRowData.employer) + " #politweet " + "http://docquery.fec.gov/cgi-bin/fecimg/?" + donationRowData.image_num ;



    // save cell for incrementing on successful tweet

    // prefill tweet for user to then edit
    $('form#new_tweet textarea#tweet_text').val(tweetText);

  });


  /////////////////////////////////////
  // TABLES INITIALIZATION AND FUNCTION
  /////////////////////////////////////


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
      {
        data: "total_donations",
        render: $.fn.dataTable.render.number( ',', '.', 0)
      },
      {data: "twitter_handle"}
    ]
  } );

  var donationsTable = $('table.donations');


  // TODO move things out of global scope
  var cellMaker = function(text, attributes){

    return "<td " + (attributes || '') + ">" + text + "</td>";
  };
  

  // Toggle canddiate donations
  $('#candidates-table tbody').on('click', 'td.expand-donations', function () {
      
    var td = $(this);
    var tr = $(this).closest('tr');
    var row = candidatesTable.row( tr );

    // hide donations
    if ( row.child.isShown() ) {
      // This row is already open - close it
      console.log('showing so hiding');
      td.text('+');
      row.child.hide();
      tr.removeClass('shown');
    }

    // show donations
    else {
      
      td.text('-');
      donations_path = "candidates/" + $(this).data('candidateId') + "/donations";

      // Grab donations and pop in data
      $.ajax(donations_path, {
        success: function(data) {
          
          console.log('data', data);

          var clonedTable = donationsTable.clone();
          data.forEach(function(donation){

            clonedTable.find('tbody').append( "<tr>" + cellMaker(donation.amount, "class='add-currency-symbol'") + cellMaker(donation.date) + cellMaker(donation.last_name) + cellMaker(donation.first_name) + cellMaker(donation.employer) + cellMaker(donation.occupation) + cellMaker(donation.state) + cellMaker(donation.city) + cellMaker(donation.fec_record_num) + "<td class='twitter-icon' data-toggle='modal' data-target='#donation-modal' data-donation-id='" + donation.id + "'></td>" + cellMaker(donation.tweet_count, "class='tweet-count'")+ cellMaker(donation.image_num) + "</tr>");

          } );

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
            
            // define column names so have access to row data object later
            columns: [
              {
                data: "amount",
                render: $.fn.dataTable.render.number( ',', '.', 0)
              },
              {data: "date"},
              {data: "last_name"},
              {data: "first_name"},
              {data: "employer"},
              {data: "occupation"},
              {data: "state"},
              {data: "city"},
              {data: "fec_record_num"},
              null,
              {
                data: "tweet_count",
                type: 'num'
              },
              {
                data: "image_num",
                visible: false
              }
            ]

          } );

        },
        error: function() {

          // TODO handle errors
          alert('Sorry, was not able to show these donations.');
        }
      });


    } //END else


  } ); // END toggle


});