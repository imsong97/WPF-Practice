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

namespace RandomNumberGame
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        int rangeVal, inputVal, randomVal;
        Random random = new Random();

        public MainWindow()
        {
            InitializeComponent();

            rangeVal = (int)range.Value;
            comValue.Text = rangeVal.ToString();
        }
        void getResult(object sender, RoutedEventArgs e)
        {
            try
            {
                rangeVal = (int)range.Value;
                randomVal = random.Next(rangeVal);
                inputVal = int.Parse(inputValue.Text);

                if (inputVal > rangeVal)
                    MessageBox.Show("입력값이 범위보다 큽니다.", "경고", MessageBoxButton.OK, MessageBoxImage.Warning);
                else
                {
                    if (randomVal == inputVal)
                    {
                        result.Text = "무 승 부";
                        result.Foreground = Brushes.Black;
                    }
                    else if (randomVal < inputVal)
                    {
                        result.Text = "승   리";
                        result.Foreground = Brushes.Blue;
                    }
                    else
                    {
                        result.Text = "패   배";
                        result.Foreground = Brushes.Red;
                    }
                }
            }
            catch
            {
                MessageBox.Show("입력값을 확인하세요.", "경고", MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }
        void restart(object sender, RoutedEventArgs e)
        {
            range.Value = 10;
            inputValue.Text = "";
            result.Text = "결   과";
            result.Foreground = Brushes.Black;
        }
        void manual(object sender, RoutedEventArgs e)
        {
            MessageBox.Show(
                "입력값이 범위 내 무작위 수보다 크면 이기는 게임 입니다.\n\n"
                + "1. 범위를 설정하세요.(0 ~ 100)\n"
                + "2. 범위 내에서 아무 숫자나 입력하세요.\n"
                + "3. START 버튼을 누르면 결과창에 결과가 표시됩니다.", 
                "Manual" , MessageBoxButton.OK, MessageBoxImage.Information);
        }
        void rangeChange(object sender, RoutedEventArgs e)
        {
            try
            {
                rangeVal = (int)range.Value;
                comValue.Text = rangeVal.ToString();
            }
            catch{}
        }
    }
}
