#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
  vec2 coord = gl_FragCoord.xy / u_resolution; // 각 픽셀들의 좌표값 normalize

  vec3 col;

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