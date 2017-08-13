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
  
  var donationsTable = $('table.donations');

  $('.accordion-body').on('show.bs.collapse', function (e) {
    var insertSpot = $(this);
    if (insertSpot.find('table.donations').length === 0) {
      donations_path = "candidates/" + $(this).data('candidateId') + "/donations";

      var cellMaker = function(text){
        return "<td>" + text + "</td>";
      };

      $.ajax(donations_path, {
        success: function(data) {
          console.log('data', data);

          var clonedTable = donationsTable.clone();
          data.forEach(function(donation){

            clonedTable.find('tbody').append( "<tr>" + cellMaker(donation.amount) + cellMaker(donation.date) + cellMaker(donation.last_name) + cellMaker(donation.first_name) + cellMaker(donation.employer) + cellMaker(donation.occupation) + cellMaker(donation.state) + cellMaker(donation.city) + cellMaker(donation.fec_record_num) + "</tr>");

          });
          insertSpot.append(clonedTable);

          // $('#main').html($(data).find('#main *'));
          // $('#notification-bar').text('The page has been successfully loaded');
        },
        error: function() {
          console.log('error');
        }
      });

    }

  });

  /* Formatting function for row details - modify as you need */
  function format ( d ) {
      // `d` is the original data object for the row
      return '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">'+
          '<tr>'+
              '<td>Full name:</td>'+
              '<td>'+d.name+'</td>'+
          '</tr>'+
          '<tr>'+
              '<td>Extension number:</td>'+
              '<td>'+d.extn+'</td>'+
          '</tr>'+
          '<tr>'+
              '<td>Extra info:</td>'+
              '<td>And any further details here (images etc)...</td>'+
          '</tr>'+
      '</table>';
  }
   

  var table = $('#example').DataTable( {
      "ajax": "../ajax/data/objects.txt",
      "columns": [
          {
              "className":      'details-control',
              "orderable":      false,
              "data":           null,
              "defaultContent": ''
          },
          { "data": "name" },
          { "data": "position" },
          { "data": "office" },
          { "data": "salary" }
      ],
      "order": [[1, 'asc']]
  } );
   
  // Add event listener for opening and closing details
  $('#example tbody').on('click', 'td.details-control', function () {
      var tr = $(this).closest('tr');
      var row = table.row( tr );

      if ( row.child.isShown() ) {
          // This row is already open - close it
          row.child.hide();
          tr.removeClass('shown');
      }
      else {
          // Open this row
          row.child( format(row.data()) ).show();
          tr.addClass('shown');
      }
  } );


});