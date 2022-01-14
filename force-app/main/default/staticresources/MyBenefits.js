google.charts.load('current', {'packages':['timeline']});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var container = document.getElementById('timeline');
        var chart = new google.visualization.Timeline(container);
        var dataTable = new google.visualization.DataTable();

        dataTable.addColumn({ type: 'string', id: 'Agency'});
        dataTable.addColumn({ type: 'string', id: 'Program'});
        dataTable.addColumn({ type: 'date', id: 'Start' });
        dataTable.addColumn({ type: 'date', id: 'End' });
        dataTable.addRows([
          ['Agency - Welfare and Supportive Services(DWSS)', 'Food Assistance', new Date(2018, 6, 4), new Date(2019, 6, 4) ],
          ['Agency - Welfare and Supportive Services(DWSS)2', 'Cash Assistance', new Date(2018, 5, 4),  new Date(2019, 5, 4) ],
          ['Agency - Welfare and Supportive Services(DWSS)3', 'Medical Assistance', new Date(2018, 5, 10),  new Date(2019, 5, 10) ],
          ['Agency - Welfare and Supportive Services(DWSS)4', 'ABC Assistance', new Date(2018, 5, 15), new Date(2019, 5, 15) ],
          ['Agency - Welfare and Supportive Services(DWSS)5', 'XYZ Assistance', new Date(2018, 5, 20),  new Date(2019, 5, 20) ],
          ['Agency - Welfare and Supportive Services(DWSS)6', 'PQR Assistance', new Date(2018, 5, 25),  new Date(2019, 5, 25) ]]);
         var options = {timeline: { showRowLabels: false }};

         chart.draw(dataTable, options);
      }