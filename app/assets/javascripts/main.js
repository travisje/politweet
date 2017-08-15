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


  $('button#donation-dummy-submit').on('click', function(){

    console.log("form#donation-dummy-submit clicked so actually submitting form");
    $('form#new_tweet').submit();
  });

  $('form#new_tweet').on('submit', function(e){
    console.log("form#new_tweet submit event");
    // e.preventDefault();



    // $(this).submit();
    // e.preventDefault();
  });

  $('#donation-modal').on('show.bs.modal', function (e) {
    // udpate form donation id value
    console.log('show modal event')
    var clickedTweetId = $(e.relatedTarget).data('donationId');
    $('form#new_tweet input#donation-id-input').val(clickedTweetId);
    // do something...
  });

  $('.twitter-icon').on('click', function(){
    console.log('twitter-icon clicked');
  });
  
  var donationsTable = $('table.donations');

  $('.accordion-body').on('show.bs.collapse', function (e) {
    

  });

  var candidatesTable = $('#candidates-table').DataTable( {
      paging:   false,
      // ordering: false,
      info:     false,
      searching: false
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

              clonedTable.find('tbody').append( "<tr>" + cellMaker(donation.amount) + cellMaker(donation.date) + cellMaker(donation.last_name) + cellMaker(donation.first_name) + cellMaker(donation.employer) + cellMaker(donation.occupation) + cellMaker(donation.state) + cellMaker(donation.city) + cellMaker(donation.fec_record_num) + "<td class='twitter-icon' data-toggle='modal' data-target='#donation-modal' data-donation-id='" + donation.id + "'></td>" + "</tr>");

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
                order: [[0, 'desc']]
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