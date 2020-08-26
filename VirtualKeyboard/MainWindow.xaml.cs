using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace VirtualKeyboard
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        TextBox tb;
        Button btn;
        private bool boolean = true;

        public MainWindow()
        {
            InitializeComponent();
        }
        private void CursorLocation(object sender, RoutedEventArgs e) // 마우스 커서 위치에 따른 TextBox 감지
        {
            tb = e.Source as TextBox;

            if (tb.Name.Equals("Edit_1"))
                tb = Edit_1; 
            else if (tb.Name.Equals("Edit_2"))
                tb = Edit_2;
            else if (tb.Name.Equals("Edit_3"))
                tb = Edit_3;
        }

        private void Shift_Click(object sender, RoutedEventArgs e) // shift
        {
            if (boolean)
                upper();
            else
                lower();
        }
        private void Enter_Click(object sender, RoutedEventArgs e) // enter
        {
            //엔터
        }
        private void Back_Click(object sender, RoutedEventArgs e) //backspace
        {
            try
            {
                tb.Text = tb.Text.Substring(0, tb.Text.Length - 1);
            }
            catch { }
        }
        private void Space_Click(object sender, RoutedEventArgs e) // space
        {
            tb.Text += " ";
        }
        private void Button_Click(object sender, RoutedEventArgs e) // Text 입력
        {
            btn = e.Source as Button;
            tb.Text += btn.Content;
            lower();
        }

        private void upper() // upper 적용
        {
            btn1.Content = "`";
            btn12.Content = "_";
            btn14.Content = "{";
            btn15.Content = "}";
            btn16.Content = ":";
            btn17.Content = "\"";
            btn18.Content = "|";
            btn19.Content = "<";
            btn20.Content = ">";

            btn_a.Content = "A";
            btn_b.Content = "B";
            btn_c.Content = "C";
            btn_d.Content = "D";
            btn_e.Content = "E";
            btn_f.Content = "F";
            btn_g.Content = "G";
            btn_h.Content = "H";
            btn_i.Content = "I";
            btn_j.Content = "J";
            btn_k.Content = "K";
            btn_l.Content = "L";
            btn_m.Content = "M";
            btn_n.Content = "N";
            btn_o.Content = "O";
            btn_p.Content = "P";
            btn_q.Content = "Q";
            btn_r.Content = "R";
            btn_s.Content = "S";
            btn_t.Content = "T";
            btn_u.Content = "U";
            btn_v.Content = "V";
            btn_w.Content = "W";
            btn_x.Content = "X";
            btn_y.Content = "Y";
            btn_z.Content = "Z";

            boolean = false;
        }
        private void lower() // lower 적용
        {
            btn1.Content = "~";
            btn12.Content = "-";
            btn14.Content = "[";
            btn15.Content = "]";
            btn16.Content = ";";
            btn17.Content = "'";
            btn18.Content = "\\";
            btn19.Content = ",";
            btn20.Content = ".";

            btn_a.Content = "a";
            btn_b.Content = "b";
            btn_c.Content = "c";
            btn_d.Content = "d";
            btn_e.Content = "e";
            btn_f.Content = "f";
            btn_g.Content = "g";
            btn_h.Content = "h";
            btn_i.Content = "i";
            btn_j.Content = "j";
            btn_k.Content = "k";
            btn_l.Content = "l";
            btn_m.Content = "m";
            btn_n.Content = "n";
            btn_o.Content = "o";
            btn_p.Content = "p";
            btn_q.Content = "q";
            btn_r.Content = "r";
            btn_s.Content = "s";
            btn_t.Content = "t";
            btn_u.Content = "u";
            btn_v.Content = "v";
            btn_w.Content = "w";
            btn_x.Content = "x";
            btn_y.Content = "y";
            btn_z.Content = "z";

            boolean = true;
        }
    }
}
