VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5700
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4500
   LinkTopic       =   "Form1"
   ScaleHeight     =   5700
   ScaleWidth      =   4500
   StartUpPosition =   3  '�t�ιw�]��
   Begin VB.CommandButton Command2 
      Caption         =   "����"
      Height          =   375
      Left            =   3240
      TabIndex        =   10
      Top             =   2760
      Width           =   735
   End
   Begin VB.TextBox Text4 
      Height          =   270
      Left            =   2160
      TabIndex        =   9
      Top             =   2160
      Width           =   615
   End
   Begin VB.TextBox Text3 
      Height          =   270
      Left            =   1560
      TabIndex        =   8
      Top             =   2160
      Width           =   615
   End
   Begin VB.TextBox Text2 
      Height          =   270
      Left            =   960
      TabIndex        =   7
      Top             =   2160
      Width           =   615
   End
   Begin VB.TextBox Text1 
      Height          =   270
      Left            =   360
      TabIndex        =   5
      Top             =   2160
      Width           =   615
   End
   Begin VB.Timer Timer1 
      Interval        =   50
      Left            =   3360
      Top             =   480
   End
   Begin MSCommLib.MSComm MSComm1 
      Left            =   3240
      Top             =   1080
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
      BaudRate        =   2400
   End
   Begin VB.CommandButton Command1 
      Caption         =   "�ɤ�"
      Height          =   375
      Left            =   3240
      TabIndex        =   3
      Top             =   2040
      Width           =   735
   End
   Begin VB.Label Label4 
      Caption         =   "�����쪺��"
      Height          =   255
      Left            =   360
      TabIndex        =   6
      Top             =   3000
      Width           =   1215
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label2 
      Caption         =   "Label2"
      Height          =   255
      Left            =   360
      TabIndex        =   4
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label Label5 
      Caption         =   "��J"
      Height          =   255
      Left            =   600
      TabIndex        =   2
      Top             =   1320
      Width           =   1095
   End
   Begin VB.Label Label3 
      Caption         =   "�{�b�ɶ�"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   840
      Width           =   1695
   End
   Begin VB.Label Label1 
      Caption         =   "�s�u���A"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   855
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim datanow As Variant
Dim data() As Byte
Dim dataA() As Byte
Dim t As Byte
Private Sub Command1_Click()
t = 8
End Sub

Private Sub Command2_Click()
t = 10
End Sub

'MSComm1.Output = a                                      '��X���
Private Sub MSComm1_OnComm()

 If MSComm1.CDHolding = True Then
        Label2.Caption = "ONLINE"
        Else
        Label2.Caption = "OFFLINE"
        
        End If
        
        If MSComm1.CommEvent = comEvReceive Then                      '�T�������ƥ�

        datanow = MSComm1.Input
data = datanow
Label1.Caption = ""
ReDim Preserve data(3)
ReDim Preserve dataA(3)

If data(3) > 128 Then
    dataA(3) = data(3) - 128
End If
    

If data(2) > 128 Then
    dataA(2) = data(2) - 128
End If

If data(1) > 128 Then
    dataA(1) = data(1) - 128
End If

If data(0) > 128 Then
    dataA(0) = data(0) - 128
End If

 Label4 = dataA(3) & dataA(2) & dataA(1) & dataA(0)
    
End If
End Sub

Private Sub Form_Load()
  MSComm1.CommPort = 1                                         '���w�Ĥ@�Ӧ�C��
  MSComm1.Settings = "1200,N,8,1"                              '�ǿ��w
  MSComm1.InputLen = 0                                         'Ū�������Ȧs�Ϥ����������e
  MSComm1.InputMode = comInputModeBinary                       '�H�G�i��Ҧ�Ū��
  MSComm1.RThreshold = 1                                       '�̤p�����r���Ƭ�1
  MSComm1.PortOpen = True                                       '�}�Ҧ�C��
  MSComm1.DTREnable = True

End Sub



Private Sub Timer1_Timer()
Label3.Caption = Format(Now, "YYYYMMDDHHMMSS")

Dim a() As Byte
ReDim a(3)

Dim x As String
x = Format(Now, "YYYYMMDDHHMMSS")
a(3) = (Mid(x, t + 1, 1))
a(2) = (Mid(x, t + 2, 1))
a(1) = (Mid(x, t + 3, 1))
a(0) = (Mid(x, t + 4, 1))

Text1.Text = a(3)
Text2.Text = a(2)
Text3.Text = a(1)
Text4.Text = a(0)

MSComm1.Output = a

End Sub



