# Convolution_logic_for_sobel_filter
주제 1	Sobel Filter를 이용한 Convolution 로직 설계

	구현 방식
	전체적인 흐름: Input image를 filter의 크기와 동일하게 쪼개서, 곱셈 연산과 덧셈을 진행하는 모듈을 만들고 그 모듈을 output의 크기만큼 반복하여 선언해주면 결과값을 얻을 수 있을 것이라는 아이디어에서 출발하였다. 
	메인 모듈: cnn
 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/8e3d90e5-b8fe-451e-a610-e5006f56bc87)

	Convolution 연산의 입력으로 쓰일 Image, Filter를 reg 타입으로 선언. Image는 input.mem 파일에서 불러온다. 
 이때, filter는 4bit의 양수로 받는다는 특징이 있다. 이는 사실 비효율적이지만, 2’s compliment로 처리를 하려다 여러 번 실패하여 양수로 입력을 받아오고 adder의 과정에서 뺄셈을 처리했다. 이는 추후 개선할 부분에서 다룰 예정이다. 

![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/4da6f941-5b1a-463b-90bb-5cb2ee3660da)

	출력을 30×30 2D라고 봤을 때 Filter와 convolution하게 되는 3×3 2D 입력을 전달하기 위해 image_0_0부터 image_0_899까지 wire 타입으로 선언.

![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/f67d6f08-5ebe-446b-ad53-4d245b9aa61c)
 
	좌측 상단부터 우측 하단까지의 convolution 결과값을 전달하기 위해 conv_out_0_0부터 conv_out_0_899까지 wire 타입으로 선언.
 
![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/b54b550a-7d15-4e45-8f56-51662d980a8a)

	ii. 에서 wire 타입으로 선언했던 image_0_n의 각 자리에 맞춰 Image 입력 전달.

![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/4588b9a2-c82a-4620-9b75-385473312df0)
 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/e7291f67-787a-4eee-bfd3-9bc239cdac63)

	CNN_Single_Layer 모듈을 불러와 convolution 연산부터 결과값 저장까지 일련의 과정들을 수행.

  
	전달해 놓은 첫 번째 convolution 연산 결과값을 Conv_out 배열로 저장하고, output.mem 파일에도 저장.

	서브 모듈: CNN_Single_Layer: Convolution 연산의 입력으로 쓰일 Image, Filter와 결과값의 출력으로 쓰일 Signed bit의 ConvResult를 port 선언.
  Image_mn의 각 자리에 맞춰 입력 받은 Image를 전달.

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/31e7d2a6-34d6-4d44-8214-f56b1d6f6020)
 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/3fd1aa05-4017-4a7a-b8c0-946335946e48)

  마찬가지로 filter_mn의 각 자리에 맞춰 입력 받은 Filter를 전달.

![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/1aa1360e-5b53-4d97-a246-56c980a6ab27)
 
	대응하는 이미지와 필터 입력의 원소 간의 곱을 MultValue_mn에 전달.

![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/b6970798-8615-42dd-98c0-a3232d4e5614)

	Adder: multiplication된 값을, RegisterFile을 통해 한 번에 전달받아 덧셈과 뺄셈을 진행합니다. Sobel filter의 값이 이미 정해져 있었기 때문에, 행 별로, 큰 수에서 작은 수를 빼고 음의 부호였던 값이 더 컸다면 2’s compliment를 진행해주는 방식을 활용했다. 이후 각 행의 결과로 나온 값은 덧셈을 진행했고 overflow를 막기 위해 bit수를 늘려주었다. 마지막은 16bit로 조정하기 위해 signed extension을 이용했다. 
 
 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/1bba35b6-11dc-4140-a017-ae40c92c2501)
![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/c2b0db39-a1eb-48aa-b62c-0ea0339d09e0)

	RegisterFile: 마지막 과제에서 쓰이던 RegisterFile을 이번 과제에 맞춰 변경하였다. write신호가 들어오면 곱셈에서 넘겨받은 값을 저장하고, read신호가 들어오면 읽는 방식이다. 하지만 ReasEn 신호는 항상 1로 입력해 두었기 때문에 항상 읽도록 되어있다. 이 신호 또한, WriteEn 신호의 다음 cycle에 켜지도록 제작했다면, 더 좋았을 것 같다. 
읽고 쓰는 주소 값은, 0,0 0,1 … 2,2 까지 일정하다. (9개의 주소 필요.) ReadData값은 값을 읽기 전, rst_n을 활용하여 초기화 한다. 
 
 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/a4d78960-52b9-4218-8f7a-061a838032fe)
![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/b10658ff-c89a-4155-ba26-9d70cdc267ed)
![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/4dc19d26-2401-4322-9b43-d6e639db37c8)

	D flip-flop: start신호에 의한 WriteEn신호가 write가 필요할 때 보다, 한 cycle 이전에 실행되어 이를 buffer로 한 신호를 미루기 위해 활용하였다. 

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/ed78881e-c0b1-4630-a551-39a498374d71)

	Multiplicator: CNN_Single_Layer내에서 쓰이는 모듈이다. 입력으로 받은 3x3 filter와 image의 일부를 3x3 크기로 자른 값의 곱셈을 진행한다.

  ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/3d41b234-8479-469d-9886-a80e64d1ee31)

filter값은 4bit로 모두 표현 가능하여, 4bit로 받아왔기 때문에 8bit값으로 extension을 진행했다. result라는 wire를 선언하여 곱한 값을 구하고 Start신호가 들어올 시, dout에 할당한다. 이외의 시간에서는 초기화로 0값을 가진다. 필터의 크기만큼 곱셈이 필요하기 때문에, CNN_Single_Layer에서 9번 필요하다. 

	Simulation (waveform 캡쳐 본 포함, in/output 설명)

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/af2d9097-72c7-499e-ae79-8e77ac03f53c)

그림 1 [Project 1]Waveform of tb_cnn.v in the simulation.
	이미지와 필터를 입력 신호로 주지 않았고, Conv_out 역시 출력하지 않았다.
	테스트 벤치 내 uut에서 끌어내 확인한 결과,
Conv_out 배열의 역순으로(899 -> 0) convolution 결과값이
잘 저장되어 있는 것을 확인할 수 있다.

	Synthesis / Implementation / Schematic
	Slice logic.
 
input으로 활용할 image를 mem파일에서 가져오고 filter값 또한 reg 형식으로 주어지기 때문에, LUT에 관한 값은 활용하지 않는 것을 알 수 있다. 
	Memory.
 
메모리 또한 따로 사용하지 않는다. 
	Dsp.
 
Dsp logic도 따로 활용하지 않는다. 
	Schematic (아래 2번 프로젝트도 같은 구조라 1번에서 구체적으로 설명)
   ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/54f3e4e8-6af8-4cf7-b1f6-251376f5e2ed)
   ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/00b74502-8f8b-4554-846d-24a34efc5989)

좌측 사진과 같이 CNN_single_Layer가 900개 배열된 것을 확인할 수 있다. 이는 output의 크기 30x30을 의미하고 하나의 CNN_single_Layer가 출력의 한 칸 값을 내보낸다는 것을 확인할 수 있다. 우측은 CNN_single_Layer의 구조이다. 9개의 곱셈기의 값을 레지스터파일이 받아 adder로 한 번에 넘겨주는 구조이다.

  ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/9082e3a2-f4da-453c-b0b9-4ebfa9fca7be)

곱셈기도 의도대로 곱한 값을 dout으로 mux를 통해 내보내는 것을 확인할 수 있다. 

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/58900622-ce22-4c4a-ae5a-828a8db9982e)

덧셈기를 보면 3개씩 묶어 계산 후, 그 3개를 비슷한 방식으로 계산하는 것을 확인할 수 있다. 다만 뺄셈기가 있어 그 구조가 덧셈기만 활용했을 때 보다 복잡한 것을 확인할 수 있다. 
 레지스터파일의 일부.

![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/2ac5dbd4-a57c-48dc-9064-102efb30b616)

주제 2	Sharpening Filter를 이용한 2 layer 2D Convolution 로직 설계

	구현 방식
	전체적인 흐름:
N×N 2D의 image와 filter를 1×N^2 1D vector처럼 생각하여
마지막 실습의 1D CNN Single Layer를 적극 활용하는 방식으로 구현했다.
첫 번째 convolution과 두 번째 convolution은
input의 크기와 불러오는 방식의 차이만 있을 뿐 구조적으로 동일하다.
	메인 모듈: cnn

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/c77f292e-6eab-4bd1-8ab8-372a45712d45)

	Convolution 연산의 입력으로 쓰일
(1st) Image, Filter와 (2nd) Conv_out, Filter_0를 reg 타입으로 선언.
Image는 input.mem 파일에서 불러온다.

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/3c2bad92-ea0c-4a8c-b019-dbd5c425119e)

	출력을 30×30 2D라고 봤을 때 Filter와 convolution하게 되는
3×3 2D 입력을 전달하기 위해 image_0_0부터 image_0_899까지
wire 타입으로 선언.

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/ae4ded35-3fcd-4403-ae4f-bbe35774f655)

	좌측 상단부터 우측 하단까지의 convolution 결과값을
전달하기 위해 conv_out_0_0부터 conv_out_0_899까지 wire 타입으로 선언.

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/3ce1d9c4-efa1-4dd0-abdd-f29135a146d9)

	ii. 에서 wire 타입으로 선언했던 image_0_n의 각 자리에 맞춰
Image 입력 전달.
	image 입력은 conv_out_0_n으로 이루어진 28×28 크기의 2D,
filter는 Filter_0(= Filter)로 변경하여 ii. ~ iv. 를 한 번 더 수행.

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/434cb602-6143-4a94-9a29-ac85eb63ba33)

	CNN_Single_Layer 모듈을 불러와 convolution 연산부터 결과값 저장까지
일련의 과정들을 수행.

  ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/97f372a2-f334-4c31-9ef9-24605ebf2756)
  ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/984513ca-ed5e-451d-97ab-ad17659cda42)

첫 필터를 거치기 위한 CNN_single_Layer 내의 모듈들은 위의, 1번 과제와 거의 동일하다. 차이점은 필터의 값이 변하여, 여전히 양수로 값을 받기 위하여 adder의 연산 구조가 변경되었을 뿐이다. (1행, 3행은 모두 음수이므로 더하고 2’s complement. 2행은 음수가 되는 값과 양수가 되는 값의 크기를 비교하여 빼고, 음수면 2’s complement 진행해주기.)
	전달해 놓은 첫 번째 convolution 연산 결과값을
Conv_out 배열로 저장하고, conv1.mem 파일에도 저장.

	두 번째 convolution 연산을 위해 vi. ~ vii. 를 한 번 더 수행.

	이때, 위의 CNN_single_Layer와 달라지는 부분은 input의 크기가 16bit인 점, output의 크기 역시 32bit로 증가한 점이다. 우리는 parameter passing방법을 적용하지 않아 이를 수정하는 과정이 오래 걸렸다. 솔직히 이를 예상하지 못했기 때문에 다음에 이런 설계를 해야하는 상황에서는 parameter passing을 활용할 것 같다. 
	서브 모듈: Project 1과 구조적으로 동일하나,
두 번째 convolution 연산 시 입출력의 bit가
Project 1이나 Project 2의 첫 번째 convolution 연산 시와 다르기에
bit 수만 수정한 서브 모듈을 사용하였다.

	Simulation (waveform 캡쳐 본 포함, in/output 설명)

 ![image](https://github.com/chunhonggi/Convolution_logic_for_sobel_filter/assets/83743927/1b23c0e1-2dfe-48f1-abb1-cce7d3406cb2)

그림 2 [Project 2]Waveform of the tb_cnn.v in the simulation.
	이미지와 필터를 입력 신호로 주지 않았고, Conv_out, Conv_out_2 역시
출력하지 않았다.
	테스트 벤치 내 uut에서 끌어내 확인한 결과,
Conv_out, Conv_out_2 배열의 역순으로(899 -> 0, 783 -> 0)
convolution 결과값이 잘 저장되어 있는 것을 확인할 수 있다.

	Synthesis / Implementation / schematic
	Slice logic.
 
input으로 활용할 image를 mem파일에서 가져오고 filter값 또한 reg 형식으로 주어지기 때문에, LUT에 관한 값은 활용하지 않는 것을 알 수 있다. 
	Memory.
 
활용 x.
	Dsp.
 
활용 x.
	Schematic
	위에서 설명한 구조와 동일한 구조를 두 번 반복한 형태로 출력이 된다.


