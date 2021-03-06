Attribute VB_Name = "Module1"
Sub stock()

Dim stock_volume As LongLong

' loop through each worksheet
For Each ws In Worksheets
    
    'place column and row headers
    ws.Range("I1").Value = "Ticker"
    ws.Range("J1").Value = "Yearly Change"
    ws.Range("K1").Value = "Percent Change"
    ws.Range("L1").Value = "Total Stock Volume"
    ws.Range("O2").Value = "Greatest % Increase"
    ws.Range("O3").Value = "Greatest % Decrease"
    ws.Range("O4").Value = "Greatest Total Volume"
    ws.Range("P1").Value = "Ticker"
    ws.Range("Q1").Value = "Value"
    ws.Range("I:L").Columns.AutoFit
    ws.Range("O2:O4").Columns.AutoFit
    ws.Range("P1:Q4").Columns.AutoFit

    'set row at which to start building results table
    tableRow = 2
    'counter for number of rows within a ticker to calculate reference for first row of ticker
    Count = 0
    'stock volume variable for sum deposit
    stock_volume = 0
    'finding the last filled row in main data on each ws
    RowCount = ws.Range("A2", ws.Range("A2").End(xlDown)).Rows.Count
    'finding the last filled row in result table on each ws
    RowCount2 = ws.Range("I2", ws.Range("I2").End(xlDown)).Rows.Count
    
    'formating the percent change results column to show 2 dec % and right align text
    ws.Range("K:K").NumberFormat = "0.00%"
    ws.Range("K:K").HorizontalAlignment = xlRight
    'formating the greatest %inc and %dec bonus results to show 2 dec %
    ws.Range("Q2:Q3").NumberFormat = "0.00%"
    
    'iterate through each row starting below headers
    For r = 2 To RowCount
        'keep count of the number of rows as moving through each ticker
        Count = Count + 1
        'calculate total stock volume
        stock_volume = stock_volume + ws.Cells(r, 7).Value
        'recognize when end of list for a ticker is reached
        If ws.Cells(r + 1, 1).Value <> ws.Cells(r, 1).Value Then
            'copy ticker name to Ticker column in results table
            ws.Cells(tableRow, 9).Value = ws.Cells(r, 1).Value
            'calculate yearly change and place with each ticker in results table
            ws.Cells(tableRow, 10).Value = ws.Cells((r - Count) + 1, 3).Value - ws.Cells(r, 6).Value
            'format yearly change result red or green for neg and pos
            If ws.Cells(tableRow, 10).Value > 0 Then
                ws.Cells(tableRow, 10).Interior.Color = RGB(0, 255, 0)
            ElseIf ws.Cells(tableRow, 10).Value < 0 Then
                ws.Cells(tableRow, 10).Interior.Color = RGB(255, 0, 0)
            End If
            'calculate percent change first while avoiding div by 0
            If ws.Cells((r - Count) + 1, 3).Value > 0 Then
                ws.Cells(tableRow, 11).Value = WorksheetFunction.IfError(((ws.Cells((r - Count) + 1, 3).Value - ws.Cells(r, 6).Value) / ws.Cells((r - Count) + 1, 3).Value), "Invalid")
            'if opening value is 0 or less, report result as n/a rather than calculate
            Else
                ws.Cells(tableRow, 11).Value = "%" & "0"
            End If
            'place stock volume with each ticker in results table
            ws.Cells(tableRow, 12).Value = stock_volume
            'move to next result table row after each iteration
            tableRow = tableRow + 1
            'reset ticker row counter and stock_volume for each new ticker
            Count = 0
            stock_volume = 0
        End If
    Next r
    'looping to fill greatest bonus table
    For r = 2 To RowCount2
        If ws.Cells(r, 11).Value > ws.Range("Q2").Value Then
            ws.Range("P2").Value = ws.Cells(r, 9).Value
            ws.Range("Q2").Value = ws.Cells(r, 11).Value
        ElseIf ws.Cells(r, 11).Value < ws.Range("Q3").Value Then
            ws.Range("P3").Value = ws.Cells(r, 9).Value
            ws.Range("Q3").Value = ws.Cells(r, 11).Value
        End If
        If ws.Cells(r, 12).Value > ws.Range("Q4").Value Then
            ws.Range("P4").Value = ws.Cells(r, 9).Value
            ws.Range("Q4").Value = ws.Cells(r, 12).Value
        End If
    Next r
Next ws


End Sub

