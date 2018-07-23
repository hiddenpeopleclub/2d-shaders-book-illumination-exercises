using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingCharacter : MonoBehaviour {

    public Vector3 StartPosition;
    public Vector3 EndPosition;
    public float Duration = 2;
    float Timer = 0;

    void Update()
    {
        Timer += Time.deltaTime;
        transform.position = Vector3.Lerp(StartPosition, EndPosition, Timer / Duration);

        if (Timer >= Duration)
            Timer = 0;
    }
}
