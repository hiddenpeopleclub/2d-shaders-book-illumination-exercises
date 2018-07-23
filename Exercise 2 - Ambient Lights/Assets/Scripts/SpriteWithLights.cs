using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteWithLights : MonoBehaviour {

	void Start () 
    {
	    	
	}

    private void OnTriggerEnter2D(Collider2D collision)
    {
        SpriteLight spriteLight = collision.gameObject.GetComponent<SpriteLight>();

        if (spriteLight)
        {
            // Check Light type and set the character up accordingly.
        }

    }


}
