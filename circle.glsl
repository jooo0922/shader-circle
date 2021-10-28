#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// 원을 그리는 함수
// 이전 예제와 마찬가지로 각 픽셀의 색상값을 리턴하여 col에 넣어줘야 하므로, 리턴값은 vec3로 지정한 것!
// 이 함수에 넣어주는 매개변수는 1. 각 픽셀 좌표값, 2. 원 위치, 3. 원 반지름 정도 넣어주면 될 것 같다. 
vec3 circle(vec2 coord, vec2 loc, float r) {
  // return vec3(1.); 이거는 처음에 함수를 지정해놨을 때, 아무것도 리턴하지 않으면 glslCanvas가 오류를 내므로 그냥 임의로 리턴해준 컬러값임.
  /*
    원이란 무엇일까?

    중심으로부터 특정 거리(반지름)만큼의 거리를 갖고 있는 점들의 모임.
    따라서, 캔버스의 각 픽셀들과 원의 중심 사이의 거리를 distance() 내장함수로 구한 뒤,
    그 거리값이 원의 반지름 r 과 어떠한 상관이 있는가를 비교해보면
    원의 영역 내에 존재하는 픽셀들과 그렇지 못한 픽셀들을 구분할 수 있겠지!

    물론 length() 내장함수를 이용해서 구해줄 수도 있음.
    이 때, length()는 distance()와 달리 하나의 매개변수,
    즉, 해당 픽셀의 좌표값(또는 원점에서 얼만큼 떨어졌는가에 해당하는 벡터값)을 넣어줘야 함.

    일반적으로 length() 가 성능이 더 빠르다고 알려져 있기 때문에
    웬만하면 length()를 써주는 게 낫다.

    d = length(coord - loc); 이런 코드로 써줬을 때,
    coord - loc 의 뜻은,
    '원의 중심(loc)으로부터 해당 픽셀(coord)까지의 거리'를 계산을 한 번 해준 다음에
    length()에 넣어준 것이라고 보면 됨.
    -> 그래서 인자값이 정확히 '좌표값' 이라기 보다 '벡터값'이라고 봐야 함.
    두 점을 잇는 벡터값(vec2)를 구한 뒤, 그 벡터의 길이(또는 크기, norm)을 계산해주는
    내장함수가 length() 라고 생각하면 됨.
    또는, 해당 벡터값(vec2)을 원점으로 옮긴다고 상상해보면,
    해당 벡터값을 좌표값으로 하는 점과 원점 사이의 거리를 구하는 것이라고 볼 수도 있음!
  */
  float d;
  // d = distance(coord, loc);
  d = length(coord - loc);

  // 그런데 우리는 d값 자체를 이용해서 방사형 그라데이션을 그리고 싶은 게 아니고,
  // 경계가 뚜렷한 원을 그리고 싶은것임.
  // 즉, 반지름(r) 을 기준으로 각 픽셀들에 대한 d값을 구분할 수 있어야 함.
  // 이 때의 경계는 r값이고, 셰이더에서 '경계'를 지어주고 싶을때는 항상 step() 내장함수를 떠올려야 함. 
  // d = step(r, d); // 이렇게 현재 d값이 r값보다 작으면 0, 크면 1을 리턴해서 d값을 갱신함.

  // 그런데, step은 경계가 너무 뚜렷하기 때문에 계단형으로 깨짐 -> aliasing 이 발생함
  // 이거를 좀 더 부드럽게 그려주려면 smoothstep()을 이용하면 됨!
  // 경계선, 경계선 + 0.01 정도를 인자로 넣어주면, 그 사이의 픽셀들은 선형보간된 리턴값이 들어갈 테니까!
  // 약간 그라데이션 되면서 경계가 부드러워지겠지! -> Antialiasing 을 수행한 것!
  // 아, 그러면 three.js에서 우리가 사용했던 antialiasing 기능이 셰이더의 smoothstep 내장함수로 구현했던 거구나!
  d = smoothstep(r, r + 0.01, d);

  // 만약 초기의 d값(즉, 각 픽셀 - 원의 중심 간의 거리)만으로 vec3 색상값을 만들어 리턴해준다면,
  // 거리가 가까운 가운데일수록 (0., 0., 0.)으로 black에 가깝고, 멀수록 (1., 1., 1.)으로 white에 가까운 방사형 그라데이션이 그려질거임.
  return vec3(d);
}

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution; // 각 픽셀들의 좌표값 normalize

  // 원의 위치는 캔버스 정가운데, 반지름은 0.3 정도 되는 원을 그리겠군
  vec3 col = circle(coord, vec2(.5), .3);

  gl_FragColor = vec4(col, 1.);
}

/*
  원 그리기


  thebookofshaders.com 예제 코드에서는
  distance(), length(), sqrt() 세 가지 내장함수를 이용해서 원을 그리고 있음.

  그렇지만 일반적으로 sqrt()는 잘 사용하지 않고,
  주로 distance() 또는 length() 를 이용해서 원 그리기에 주로 사용함.

  그래서 이 예제에서도 두 내장함수를 중심으로 원 그리기를 구현할 것임.
*/

/*
  void main() {
    vec2 coord = gl_FragCoord.xy / u_resolution;

    vec3 col;

    gl_FragColor = vec4(col, 1.);
  }

  이 코드는 지난 번 예제에서도 봤듯이
  어떤 셰이더를 작성하건 간에 항상 default로 써주고 시작해야 하는 코드
*/