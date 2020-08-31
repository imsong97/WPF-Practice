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
        KeyWindow kw = new KeyWindow();
        public static bool boolean = true;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void CursorLocation(object sender, RoutedEventArgs e) // 마우스 커서 더블클릭으로 textbox focus
        {
            KeyWindow.tb = e.Source as TextBox;
            
            kw.Show();
            kw.WindowState = WindowState.Normal;
            //KeyboardControl(boolean);
        }

        /*private void KeyboardControl(bool b)
        {
            try
            {
                if (b)
                {
                    kw.Show();
                    boolean = false;
                }
                else
                {
                    kw.Hide();
                    boolean = true;
                }
            }
            catch{  }
        }*/
    }
}
